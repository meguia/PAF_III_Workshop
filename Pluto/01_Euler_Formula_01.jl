### A Pluto.jl notebook ###
# v0.20.19

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

# ╔═╡ 8fb0fb30-6b05-4fda-8f4c-1716c04317ba
md"""
# Derivatives of Trigonometric and Exponential Functions

$$\begin{aligned}
&\begin{array}{|c|c|c|c|c}
\hline \hline  f(x)  & f^{\prime}(x) & f^{\prime\prime}(x) & f^{\prime\prime\prime}(x) & f^{\prime\prime\prime\prime}(x) \\
\hline sin(x) & cos(x) & -sin(x) & -cos(x) & sin(x) \\
cos(x) & -sin(x) & -cos(x) & sin(x) & cos(x)\\
e^x & e^x & e^x & e^x & e^x \\
e^{ax} & a e^{ax} & a^2 e^{ax} & a^3 e^{ax} & a^4 e^{ax} \\
e^{ix} & i e^{ix} & -e^{ix} & -i e^{ix} & e^{ix} \\
\hline
\end{array}
\end{aligned}$$


"""

# ╔═╡ 0cb016b6-c2fa-4ffb-9047-1869b7e11a91
md"""
# Taylor Series of Trigonometric Functions

$sin(x) = \cancel{sin(0)} + cos(0)x - \cancel{\frac{sin(0)}{2!} x^2} - \frac{cos(0)}{3!} x^3 + \cancel{\frac{sin(0)}{4!} x^4} + \frac{cos(0)}{5!} x^5 - \cancel{\frac{sin(0)}{6!} x^6} - \frac{cos(0)}{7!} x^7 + ...$
$cos(x) = cos(0) - \cancel{sin(0)x} - \frac{cos(0)}{2!} x^2 + \cancel{\frac{sin(0)}{3!} x^3} + \frac{cos(0)}{4!} x^4 - \cancel{\frac{sin(0)}{5!} x^5} - \frac{cos(0)}{6!} x^6 + \cancel{\frac{sin(0)}{7!} x^7} + ...$

$\sin(0)=0$
$\cos(0)=1$

$sin(x) = x - \frac{1}{3!} x^3 + \frac{1}{5!} x^5 - \frac{1}{7!} x^7 + ...$
$cos(x) = 1 - \frac{1}{2!} x^2 + \frac{1}{4!} x^4 - \frac{1}{6!} x^6 + ...$
$$\require{cancel}$$  
"""

# ╔═╡ 9aed1478-bb99-4f89-afee-bd6c146782f2
md"""
# Taylor Series of Exponential Function

$e^x = e^0 + e^0 x + \frac{e^0}{2!} x^2 + \frac{e^0}{3!} x^3 + \frac{e^0}{4!} x^4 + \frac{e^0}{5!} x^5 + \frac{e^0}{6!} x^6 + \frac{e^0}{7!} x^7 + ...$ 

$e^x = 1 + x + \frac{1}{2!} x^2 + \frac{1}{3!} x^3 + \frac{1}{4!} x^4 + \frac{1}{5!} x^5 + \frac{1}{6!} x^6 + \frac{1}{7!} x^7 + ...$ 

$e^{ix} = 1 + ix - \frac{1}{2!} x^2 - i\frac{1}{3!} x^3 + \frac{1}{4!} x^4 + i\frac{1}{5!} x^5 - \frac{1}{6!} x^6 - i\frac{1}{7!} x^7 + ...$

$e^{ix} = \left( 1  - \frac{1}{2!} x^2 + \frac{1}{4!} x^4  - \frac{1}{6!} x^6  + ... \right)
+ i \left( x - \frac{1}{3!} x^3 + \frac{1}{5!} x^5 - \frac{1}{7!} x^7 + ... \right)$

$e^{ix} = \cos(x) + i \sin(x)$





"""

# ╔═╡ 66ed5572-84d7-4780-a983-161b854a9cc1
md"""
# Euler's Formula
"""

# ╔═╡ 86558140-3c35-4e7d-b534-4e71389b81f3
md"""
Every complex number $z$ can be expressed through their radius (or modulus) $r$ and angle $\theta$ 
as:

$z = r e^{i\theta}$

using Euler

$z = r \cos(\theta) + i r \sin(\theta)$

the real part is the projection on the real axis $r \cos(\theta)$ and the imaginary part is the projection on the imaginary axis $r \sin(\theta)$
"""

# ╔═╡ f46c59db-3ddc-4683-aaa2-4e443558901e
md"""
r $(@bind A Slider(0:0.01:2,default=1.0;show_value=true)) \
θ $(@bind θ Slider(-pi:pi/12:pi,default=0.0;show_value=x->round(x,digits=2)))
"""

# ╔═╡ 4fdc6730-94d7-4b83-b346-d620c7e92bb6
begin
	x0 = A*cos(θ)
	y0 = A*sin(θ)
	
	plot([-2,2],[0,0],ls=:dash,c=:gray,label="",xlims=(-2,2),ylims=(-2,2),size=(500,500))
	plot!([0,0],[-2,2],ls=:dash,c=:gray,label="",xlabel="Real",ylabel="Imaginary")
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
		annotate!(0.7*x0,0.7*y0+0.1,text(latexstring("r")))
	end	
	annotate!(x0,-0.1*sign(y0),text(latexstring("r\\cos(\\theta)")))
	if x0>0
		annotate!(0,y0+0.1,text(latexstring("r\\sin(\\theta)"),:right))
	else
		annotate!(0,y0+0.1,text(latexstring("r\\sin(\\theta)"),:left))
	end	
end	

# ╔═╡ 7172ae6c-910c-46c2-8f8b-e1f04703fce0
md"""
## Complex conjugate

The complex conjugate of z can be obtained by changing the sign of the angle $\theta$

$\overline{z} = re^{-i\theta} = r\cos(\theta) + ir\sin(-i\theta) = r\cos(\theta) - ir\sin(i\theta)$

The product of z by its complex conjugate is equal to the square of the radius:

$z\overline{z} = re^{i\theta}re^{-i\theta} = rr e^{i\theta-i\theta} = r^2 e^0 = r^2$
"""

# ╔═╡ 0b08da7d-117f-49f4-8bc5-edfb7ed7602c
md"""
r $(@bind A2 Slider(0:0.01:1.41,default=1.0;show_value=true)) \
θ $(@bind θ2 Slider(-pi:pi/12:pi,default=0.0;show_value=x->round(x,digits=2)))
"""

# ╔═╡ 8af8012f-15e0-4b93-81fa-b3dc37ec919b
begin
	x02 = A2*cos(θ2)
	y02 = A2*sin(θ2)
	plot([-2,2],[0,0],ls=:dash,c=:gray,label="",xlims=(-2,2),ylims=(-2,2),size=(500,500))
	plot!([0,0],[-2,2],ls=:dash,c=:gray,label="",xlabel="Real",ylabel="Imaginary")
	plot!([0,x02],[0,y02],c=:black,label="")
	plot!([x02,x02],[0,y02],ls=:dash,c=:red,label="")
	plot!([0,x02],[y02,y02],ls=:dash,c=:red,label="")
	scatter!([x02],[y02],c=:red,ms=5,label=latexstring("z"))
	plot!([0,x02],[0,-y02],c=:black,label="")
	if abs(θ2)>pi/50
		arcx2 = A2/3*cos.(0:sign(θ2)*pi/100:θ2)
		arcy2 = A2/3*sin.(0:sign(θ2)*pi/100:θ2)
		plot!(arcx2,arcy2,ls=:dash,c=:green,label="")
		plot!(arcx2,-arcy2,ls=:dash,c=:green,label="")
		annotate!(0.3*A*cos(θ2/2),0.3*A*sin(θ2/2),text(latexstring("\\theta"),:green))
		annotate!(0.3*A*cos(θ2/2),-0.3*A*sin(θ2/2),text(latexstring("-\\theta"),:green))
	end
	plot!([x02,x02],[0,-y02],ls=:dash,c=:blue,label="")
	plot!([0,x02],[-y02,-y02],ls=:dash,c=:blue,label="")
	scatter!([x02],[-y02],c=:blue,ms=5,label=latexstring("\\overline{z}"))
	plot!([0,A2^2],[0,0],c=:black,label="")
	scatter!([A2^2],[0],c=:black,ms=5,label=latexstring("z\\overline{z}"))
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
    max-width: 1000px;
}
input[type*="range"] {
	width: 40%;
}
</style>
"""

# ╔═╡ Cell order:
# ╟─8fb0fb30-6b05-4fda-8f4c-1716c04317ba
# ╟─0cb016b6-c2fa-4ffb-9047-1869b7e11a91
# ╟─9aed1478-bb99-4f89-afee-bd6c146782f2
# ╟─66ed5572-84d7-4780-a983-161b854a9cc1
# ╟─86558140-3c35-4e7d-b534-4e71389b81f3
# ╟─4fdc6730-94d7-4b83-b346-d620c7e92bb6
# ╟─f46c59db-3ddc-4683-aaa2-4e443558901e
# ╟─7172ae6c-910c-46c2-8f8b-e1f04703fce0
# ╟─8af8012f-15e0-4b93-81fa-b3dc37ec919b
# ╟─0b08da7d-117f-49f4-8bc5-edfb7ed7602c
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─f57150d3-14af-4c28-b2d7-cc293a3f93c4
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
