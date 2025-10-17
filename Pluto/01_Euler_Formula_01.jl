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
θ $(@bind θ Slider(0:pi/12:2*pi,default=0.0;show_value=x->round(x,digits=2)))
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
end	

# ╔═╡ 240f065d-067b-4888-b9db-0dcfae91b81d
# ╠═╡ disabled = true
#=╠═╡
md"""
# RADIANS
"""
  ╠═╡ =#

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
# ╟─240f065d-067b-4888-b9db-0dcfae91b81d
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─f57150d3-14af-4c28-b2d7-cc293a3f93c4
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
