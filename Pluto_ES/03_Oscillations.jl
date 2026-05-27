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

# ╔═╡ 45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╠═╡ show_logs = false
begin
	import Pkg;
	Pkg.activate(Base.current_project());
	Pkg.instantiate();
	using Plots, PlutoUI, LaTeXStrings, PlutoEditorColorThemes, Latexify, Measures, ProjectRoot
end

# ╔═╡ f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╠═╡ show_logs = false
include("../iii_utils.jl");

# ╔═╡ 83f8450d-3225-4f37-ba5d-9f510cf0d497
md"""
# Oscilaciones

## Oscilaciones elementales (tonos puros)

Una oscilacion elemental puede escribirse como

$s(t)=Ae^{i\omega t}$.

Es un punto que gira en el plano complejo con radio $A$ y fase $\theta(t)=\omega t$. La frecuencia angular $\omega$ indica cuantos radianes por segundo avanza la fase.

La parte real es $A\cos(\omega t)$ y la parte imaginaria es $A\sin(\omega t)$. Ambas son sombras del mismo movimiento circular.
"""

# ╔═╡ 8ba30273-6d98-439f-910c-f0bd589d543d
begin
	@bind t_1 Clock(0.1,true,false,401,true)
end

# ╔═╡ a0af0068-1933-4760-9fc1-c7959b3f74b8
md"""
A $(@bind Amp Slider(0:0.01:2,default=1.0;show_value=true)) \
omega $(@bind ω Slider(1.0:0.1:5.0,default=1.0;show_value=true))

$A$ cambia el tamano del circulo y $\omega$ cambia la rapidez del giro.
"""

# ╔═╡ 50f48ea1-228c-493d-9d55-a2ada49248b7
begin
	t1 = (t_1-1)*(2*pi)/100
	x1 = Amp*cos(ω*t1)
	y1 = Amp*sin(ω*t1)
	p1, p2 = plot_ntones(t1,[Amp],[ω],[0],2.1)
	plot(p1,p2, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],bottom_margin=[7mm 7mm],size=(1200,430))
end	

# ╔═╡ 181f52a6-d355-4d7b-8f4f-46614c6d1647
md"""
Grafica de las partes real e imaginaria.
"""

# ╔═╡ 1fe438b6-0208-48ac-86bf-e02da1ba4017
md"""
## Oscilaciones elementales con fase inicial

Para combinar oscilaciones conviene permitir un angulo inicial $\phi$:

$s(t)=Ae^{i(\omega t+\phi)}$

Tambien se puede escribir usando una amplitud compleja $C=Ae^{i\phi}$:

$s(t)=Ce^{i\omega t}$.

La fase no cambia la frecuencia; desplaza la oscilacion en el tiempo.
"""

# ╔═╡ 7e060b26-118c-445b-be90-8034517ec277
md"""
## Suma de oscilaciones elementales

Sumamos tres oscilaciones con velocidades angulares $\omega=1,2,3$ rad/s:

$s(t)=A_1e^{i\phi_1}e^{it}+A_2e^{i\phi_2}e^{i2t}+A_3e^{i\phi_3}e^{i3t}$.

Cada termino es una flecha que gira con su propio radio y fase. Las amplitudes determinan el peso de cada componente; las fases determinan como se alinean entre si. La forma de onda cambia, pero el periodo base sigue siendo $2\pi$.
"""

# ╔═╡ c8bf120f-b2dc-4e90-90e7-12d2fdb1c660
@bind t_2 Clock(0.1,true,false,401, true)

# ╔═╡ e23c472d-fcfd-4183-8849-11b14f8aeaca
md"""
## Hacer real la oscilacion

Una senal real se obtiene combinando pares de frecuencias opuestas. Las partes imaginarias se cancelan cuando los coeficientes estan emparejados correctamente.
"""

# ╔═╡ 444dc569-d181-4dbf-8764-afc34c495cfa
@bind t_3 Clock(0.1,true,false,401,false)

# ╔═╡ b708f59c-905d-45d8-8a48-70b3bb534af5
begin
	# this is a comment
	stylefile = joinpath(@projectroot,"Pluto","light_33.css")
	PlutoEditorColorThemes.setcolortheme!(stylefile)
end

# ╔═╡ 18267cb1-99b8-4ed4-8558-1de0bdae4795
html"""
<style>
pluto-notebook {
    max-width: 1000px;
}
input[type*="range"] {
	width: 25%;
}
pluto-helpbox { display: none; } 
</style>
"""

# ╔═╡ 234a88c7-314b-419e-9092-7d00be674b2b
sp = html"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";

# ╔═╡ 0e34247d-671a-46b3-be5b-3f4545d848f0
md"""
omega = 1 : $sp A1 = $(@bind A1 Slider(0:0.02:1,default=1.0;show_value=true)) $sp
phi1 = $(@bind ϕ1 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
omega = 2 : $sp A2 = $(@bind A2 Slider(0:0.02:1,default=0.0;show_value=true)) $sp
phi2 = $(@bind ϕ2 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
omega = 3 : $sp A3 = $(@bind A3 Slider(0:0.02:1,default=0.0;show_value=true)) $sp
phi3 = $(@bind ϕ3 Slider(0:0.02:6.28,default=0.0;show_value=true)) \

Explora como las componentes se suman en el plano complejo y en la forma de onda.
"""

# ╔═╡ 5b5f4a93-e1c1-4c55-84fd-544735cd38e5
begin
	Amax = 3.5
	t2 = (t_2-1)*(4*pi)/400
	Amps = [A1, A2, A3]
	ωs = [1,2,3]
	ϕs = [ϕ1,ϕ2,ϕ3]
	p1b, p2b = plot_ntones(t2,Amps,ωs,ϕs,Amax;plot_trace=true)
	plot(p1b,p2b,layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],bottom_margin=[7mm 7mm],size=(1200,430))
end	

# ╔═╡ 49bac738-151a-40c0-b64f-8d52dba998d3
begin
	p1c, p2c = plot_ntones_vertical(t2,Amps,ωs,ϕs,Amax)
	plot(p1c,p2c, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm], bottom_margin=[7mm 7mm],size=(1200,730))
end	

# ╔═╡ bf3be160-d8f8-4302-8ece-b4f9826c94be
md"""
omega = 1 : $sp A1 = $(@bind A1p Slider(0:0.02:1,default=1.0;show_value=true)) $sp
phi1 = $(@bind ϕ1p Slider(0:0.02:6.28,default=0.0;show_value=true)) \
omega = -1 : $sp A-1 = $(@bind A1n Slider(0:0.02:1,default=0.0;show_value=true)) $sp
phi-1 = $(@bind ϕ1n Slider(0:0.02:6.28,default=0.0;show_value=true)) \

Las frecuencias positiva y negativa giran en sentidos opuestos.
"""

# ╔═╡ 289b5138-824a-4321-9f24-35597c6f7f6f
begin
	t3 = (t_3-1)*(4*pi)/400
	l = @layout [[a{0.33w, 0.33h} b{0.66w}]; c{0.33w, 0.66h} _{0.66w}]
	p1d, p2d, p3d = plot_ntones_twoaxis(t3,[A1p,A1n],[1,-1],[ϕ1p,ϕ1n],2.1)
	plot(p1d,p2d,p3d,layout=l, left_margin=[10mm -13mm],top_margin=[-10mm 13mm],size=(1200,1200))
end	

# ╔═╡ c2893d7b-8c84-44cb-8a8f-3b72a93e3450
begin
	l2 = @layout [[a{0.33w, 0.33h} b{0.66w}]; c{0.33w, 0.66h} _{0.66w}]
	plts = plot_ntones_twoaxis(t1,[Amp],[ω],[0],2.1;ncycles=1)
	plot(plts...,layout=l, left_margin=[10mm -13mm],top_margin=[-10mm 13mm],size=(1200,1200))
end	

# ╔═╡ Cell order:
# ╟─83f8450d-3225-4f37-ba5d-9f510cf0d497
# ╟─8ba30273-6d98-439f-910c-f0bd589d543d
# ╟─a0af0068-1933-4760-9fc1-c7959b3f74b8
# ╟─50f48ea1-228c-493d-9d55-a2ada49248b7
# ╟─181f52a6-d355-4d7b-8f4f-46614c6d1647
# ╟─c2893d7b-8c84-44cb-8a8f-3b72a93e3450
# ╟─1fe438b6-0208-48ac-86bf-e02da1ba4017
# ╟─7e060b26-118c-445b-be90-8034517ec277
# ╟─c8bf120f-b2dc-4e90-90e7-12d2fdb1c660
# ╟─0e34247d-671a-46b3-be5b-3f4545d848f0
# ╟─5b5f4a93-e1c1-4c55-84fd-544735cd38e5
# ╟─49bac738-151a-40c0-b64f-8d52dba998d3
# ╟─e23c472d-fcfd-4183-8849-11b14f8aeaca
# ╟─bf3be160-d8f8-4302-8ece-b4f9826c94be
# ╟─444dc569-d181-4dbf-8764-afc34c495cfa
# ╟─289b5138-824a-4321-9f24-35597c6f7f6f
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─b708f59c-905d-45d8-8a48-70b3bb534af5
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─234a88c7-314b-419e-9092-7d00be674b2b
