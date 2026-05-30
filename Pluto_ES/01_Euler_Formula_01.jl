### A Pluto.jl notebook ###
# v0.20.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╠═╡ show_logs = false
begin
	import Pkg; Pkg.activate(Base.current_project());Pkg.instantiate()
	using Plots, PlutoUI,Symbolics, Latexify, LaTeXStrings, Measures, ProjectRoot, PlutoEditorColorThemes
end

# ╔═╡ 66ed5572-84d7-4780-a983-161b854a9cc1
md"""
# Formula de Euler
"""

# ╔═╡ 86558140-3c35-4e7d-b534-4e71389b81f3
md"""
Todo numero complejo $z$ puede describirse por su radio o modulo $|z|$ y por su angulo $\theta$:

$z = |z| e^{i\theta}$

La formula de Euler dice que

$e^{i\theta}=\cos(\theta)+i\sin(\theta)$

por lo tanto

$z = |z|\cos(\theta) + i |z|\sin(\theta)$

La parte real es la proyeccion sobre el eje real y la parte imaginaria es la proyeccion sobre el eje imaginario. El numero complejo puede leerse entonces como un vector de modulo $|z|$ que sale del origen y que apunta en la direccion $\theta$.

Esta forma tambien muestra por que la multiplicacion de complejos tiene una interpretacion geometrica simple: al multiplicar, los modulos se multiplican y los angulos se suman. Es decir, multiplicar por un complejo equivale a estirar o achicar y despues rotar.
"""

# ╔═╡ f46c59db-3ddc-4683-aaa2-4e443558901e
md"""
|z| $(@bind A Slider(0:0.01:2,default=1.0;show_value=true)) \
theta $(@bind θ Slider(-pi:pi/12:pi,default=0.0;show_value=x->round(x,digits=2)))

Mover el modulo (radio) y el angulo para ver como cambian las proyecciones real e imaginaria.
"""

# ╔═╡ 4fdc6730-94d7-4b83-b346-d620c7e92bb6
begin
	x0 = A*cos(θ)
	y0 = A*sin(θ)
	plot([-2,2],[0,0],ls=:dash,c=:gray,label="",xlims=(-2,2),ylims=(-2,2),size=(400,400))
	plot!([0,0],[-2,2],ls=:dash,c=:gray,label="",xlabel="Real",ylabel="Imaginario")
	plot!([0,x0],[0,y0],c=:black,label="")
	plot!([x0,x0],[0,y0],ls=:dash,c=:red,label="")
	plot!([0,x0],[y0,y0],ls=:dash,c=:red,label="")
	scatter!([x0],[y0],c=:red,ms=5,label="")
	if abs(θ)>pi/50
		arcx = A/3*cos.(0:sign(θ)*pi/100:θ)
		arcy = A/3*sin.(0:sign(θ)*pi/100:θ)
		plot!(arcx,arcy,ls=:dash,c=:green,label="")
		annotate!(0.3*A*cos(θ/2),0.3*A*sin(θ/2),text(latexstring("\\theta"),:green))
	end
	if A>0.1
		annotate!(0.7*x0,0.7*y0+0.1,text(latexstring("|z|")))
	end	
	annotate!(x0,-0.1*sign(y0),text(latexstring("|z|\\cos(\\theta)")))
	if x0>0
		annotate!(0,y0+0.1,text(latexstring("|z|\\sin(\\theta)"),:right))
	else
		annotate!(0,y0+0.1,text(latexstring("|z|\\sin(\\theta)"),:left))
	end	
end	

# ╔═╡ 12553b12-a46d-4b46-850c-a738f2b246cb
md"""
## Visualizacion de la regla anterior

Ya explicamos como se multiplican complejos. Ahora usemos esa regla como herramienta geometrica.

En el grafico, $z_1$ esta en rojo, $z_2$ en azul y el producto $z_1z_2$ en magenta. Puedes leer la multiplicacion como una transformacion aplicada a $z_1$: el modulo de $z_2$ estira o achica la flecha roja, y el angulo de $z_2$ la rota.

Los valores debajo del control muestran el modulo y el angulo que resultan de esa transformacion.
"""

# ╔═╡ 1f7971af-5bfc-461f-babd-7d339a736c2b
md"""
|z₁| $(@bind A1 Slider(0:0.01:2,default=1.0;show_value=true)) 
θ₁ $(@bind θ1 Slider(-pi:pi/12:pi,default=0.0;show_value=x->round(x,digits=2))) \
|z₂| $(@bind A2 Slider(0:0.01:2,default=1.0;show_value=true)) 
θ₂ $(@bind θ2 Slider(-pi:pi/12:pi,default=0.0;show_value=x->round(x,digits=2)))
"""

# ╔═╡ 995a22c9-4f0e-484c-a3a3-b5733b07385c
begin
	x01 = A1*cos(θ1)
	y01 = A1*sin(θ1)
	x02 = A2*cos(θ2)
	y02 = A2*sin(θ2)
	x012 = A1*A2*cos(θ1+θ2)
	y012 = A1*A2*sin(θ1+θ2)
	limprod = max(2.0, A1 + 0.2, A2 + 0.2, A1*A2 + 0.2)
	pp = plot([-limprod,limprod],[0,0],ls=:dash,c=:gray,label="",xlims=(-limprod,limprod),ylims=(-limprod,limprod),size=(500,500))
	plot!([0,0],[-limprod,limprod],ls=:dash,c=:gray,label="",xlabel="Real",ylabel="Imaginario")
	plot!([0,x01],[0,y01],c=:black,label="")
	#plot!([x01,x01],[0,y01],ls=:dash,c=:red,label="")
	#plot!([0,x01],[y01,y01],ls=:dash,c=:red,label="")
	scatter!([x01],[y01],c=:red,ms=5,label=latexstring("z_1"))
	if abs(θ1)>pi/50
		arcx1 = A1/3*cos.(0:sign(θ1)*pi/100:θ1)
		arcy1 = A1/3*sin.(0:sign(θ1)*pi/100:θ1)
		plot!(arcx1,arcy1,ls=:dash,c=:green,label="")
		annotate!(0.3*A1*cos(θ1/2),0.3*A1*sin(θ1/2),text(latexstring("\\theta_1"),:green))
	end
	plot!([0,x02],[0,y02],c=:black,label="")
	#plot!([x02,x02],[0,y02],ls=:dash,c=:blue,label="")
	#plot!([0,x02],[y02,y02],ls=:dash,c=:blue,label="")
	scatter!([x02],[y02],c=:blue,ms=5,label=latexstring("z_2"))
	if abs(θ2)>pi/50
		arcx2 = A2/3*cos.(0:sign(θ2)*pi/100:θ2)
		arcy2 = A2/3*sin.(0:sign(θ2)*pi/100:θ2)
		plot!(arcx2,arcy2,ls=:dash,c=:green,label="")
		annotate!(0.3*A2*cos(θ2/2),0.3*A2*sin(θ2/2),text(latexstring("\\theta_2"),:green))
	end
	plot!([0,x012],[0,y012],c=:black,label="")
	#plot!([x02,x02],[0,y02],ls=:dash,c=:magenta,label="")
	#plot!([0,x02],[y02,y02],ls=:dash,c=:magenta,label="")
	scatter!([x012],[y012],c=:magenta,ms=5,label=latexstring("z_1 z_2"))
	if abs(θ2+θ1)>pi/50
		arcx12 = A1*A2/1.5*cos.(0:sign(θ1+θ2)*pi/100:θ1+θ2)
		arcy12 = A1*A2/1.5*sin.(0:sign(θ1+θ2)*pi/100:θ1+θ2)
		plot!(arcx12,arcy12,ls=:dash,c=:green,label="")
		annotate!(A1*A2*cos((θ1+θ2)/2),A1*A2*sin((θ1+θ2)/2),text(latexstring("\\theta_1+\\theta_2"),:green))
	end
	pp
end	

# ╔═╡ 7172ae6c-910c-46c2-8f8b-e1f04703fce0
md"""
## Conjugado complejo

El conjugado complejo de $z$ se obtiene cambiando el signo del angulo:

$\overline{z}=re^{-i\theta}=r\cos(\theta)-ir\sin(\theta)$

Geometricamente es una reflexion respecto del eje real. Al multiplicar un numero por su conjugado, las rotaciones se cancelan:

$z\overline{z}=re^{i\theta}re^{-i\theta}=r^2$

El resultado queda sobre el eje real y vale el cuadrado del modulo.
"""

# ╔═╡ 0b08da7d-117f-49f4-8bc5-edfb7ed7602c
md"""
|z| $(@bind A3 Slider(0:0.01:1.41,default=1.0;show_value=true)) \
θ $(@bind θ3 Slider(-pi:pi/12:pi,default=0.0;show_value=x->round(x,digits=2)))

El punto azul es el conjugado y el punto negro representa $z\overline{z} = |z|^2$.
"""

# ╔═╡ 8af8012f-15e0-4b93-81fa-b3dc37ec919b
begin
	x03 = A3*cos(θ3)
	y03 = A3*sin(θ3)
	plot([-2,2],[0,0],ls=:dash,c=:gray,label="",xlims=(-2,2),ylims=(-2,2),size=(400,400))
	plot!([0,0],[-2,2],ls=:dash,c=:gray,label="",xlabel="Real",ylabel="Imaginario")
	plot!([0,x03],[0,y03],c=:black,label="")
	plot!([x03,x03],[0,y03],ls=:dash,c=:red,label="")
	plot!([0,x03],[y03,y03],ls=:dash,c=:red,label="")
	scatter!([x03],[y03],c=:red,ms=5,label=latexstring("z"))
	plot!([0,x03],[0,-y03],c=:black,label="")
	if abs(θ3)>pi/50
		arcx3 = A3/3*cos.(0:sign(θ3)*pi/100:θ3)
		arcy3 = A3/3*sin.(0:sign(θ3)*pi/100:θ3)
		plot!(arcx3,arcy3,ls=:dash,c=:green,label="")
		plot!(arcx3,-arcy3,ls=:dash,c=:green,label="")
		annotate!(0.3*A3*cos(θ3/2),0.3*A3*sin(θ3/2),text(latexstring("\\theta"),:green))
		annotate!(0.3*A3*cos(θ3/2),-0.3*A3*sin(θ3/2),text(latexstring("-\\theta"),:green))
	end
	plot!([x03,x03],[0,-y03],ls=:dash,c=:blue,label="")
	plot!([0,x03],[-y03,-y03],ls=:dash,c=:blue,label="")
	scatter!([x03],[-y03],c=:blue,ms=5,label=latexstring("\\overline{z}"))
	plot!([0,A3^2],[0,0],c=:black,label="")
	scatter!([A3^2],[0],c=:black,ms=5,label=latexstring("z\\overline{z}"))
end	

# ╔═╡ f57150d3-14af-4c28-b2d7-cc293a3f93c4
begin
	# this is a comment
	stylefile = joinpath(@projectroot,"Pluto","light_33.css")
	PlutoEditorColorThemes.setcolortheme!(stylefile)
end

# ╔═╡ 18267cb1-99b8-4ed4-8558-1de0bdae4795
html"""
<style>
pluto-notebook {
    max-width: 1200px;
}
input[type*="range"] {
	width: 40%;
}
pluto-helpbox { display: none; } 
</style>
"""

# ╔═╡ 89061a23-d01a-4b5d-a861-5dfd85d1d168
sp = html"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";

# ╔═╡ 0c304f71-c0d1-4154-b264-e476f0d16e0d
md"""
|z₁||z₂| = $(round(A1*A2,digits=2))  $sp $sp $sp $sp $sp θ₁+θ₂ = $(round(θ1+θ2,digits=2))
"""

# ╔═╡ Cell order:
# ╟─66ed5572-84d7-4780-a983-161b854a9cc1
# ╟─86558140-3c35-4e7d-b534-4e71389b81f3
# ╟─4fdc6730-94d7-4b83-b346-d620c7e92bb6
# ╟─f46c59db-3ddc-4683-aaa2-4e443558901e
# ╟─12553b12-a46d-4b46-850c-a738f2b246cb
# ╟─1f7971af-5bfc-461f-babd-7d339a736c2b
# ╟─0c304f71-c0d1-4154-b264-e476f0d16e0d
# ╟─995a22c9-4f0e-484c-a3a3-b5733b07385c
# ╟─7172ae6c-910c-46c2-8f8b-e1f04703fce0
# ╟─8af8012f-15e0-4b93-81fa-b3dc37ec919b
# ╟─0b08da7d-117f-49f4-8bc5-edfb7ed7602c
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─f57150d3-14af-4c28-b2d7-cc293a3f93c4
# ╠═18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╠═89061a23-d01a-4b5d-a861-5dfd85d1d168
