### A Pluto.jl notebook ###
# v0.20.18

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
import Pkg; Pkg.activate()

# ╔═╡ 1f093de0-9501-11ef-30d2-4f854ecfb2e5
using Plots, PlutoUI, LaTeXStrings, Latexify, Measures

# ╔═╡ f701ab61-2512-4f2a-a182-a6f2b23e0bd2
include("../iii_utils.jl")

# ╔═╡ 240f065d-067b-4888-b9db-0dcfae91b81d
md"""
# Euler Formula
## Geometrical Interpretation

### Position and velocity. 

If we define the position of a particle as a function of time $s(t)$. 

The instantaneous velocity is, by definition, its first derivative $v(t) = s^{\prime}(t)$. 

On the number line, $s(t)$ is a signed position. 

The velocity $v(t)$ is the rate of change of that distance at time t.

"""

# ╔═╡ b3488a41-98c0-4816-91e8-8a9d867689fd
begin
	@bind t0_1 Clock(0.1,true,false,61,false)
end

# ╔═╡ a321b881-11e7-408c-a71e-8ba2ddb632ff
begin
	s0 = 1.0
	t01 = (t0_1-1)*0.1
	v01 = 1.0
	s01 = s0+t01*v01
	plot_velocity(t01,s01,v01,min(s01,-1),max(s01+v01,11))
	annotate!((0.0,-0.3,text(latexstring("s(t)=1+vt"),15,:black,:left)))
end	

# ╔═╡ 667886da-feaf-4bdc-b2d7-9860ce651b8a
md"""
α $(@bind a1 Slider(0.1:0.1:1.0,default=0.5;show_value=true)) \
"""

# ╔═╡ 3bfe1b5b-0aa0-4171-9469-99401c09afda
begin
	@bind t0_2 Clock(0.1,true,false,floor(Int,46/a1),false)
end

# ╔═╡ 3870562d-e580-4f5d-83d5-804da16432ff
begin
	t02 = (t0_2-1)*0.1
	s02 = exp(a1*t02)
	v02 = a1*exp(a1*t02)
	plot_velocity(t02,s02,v02,min(s02,-1),max(s02+v02,11))
	annotate!((0.0,-0.3,text(latexstring("s(t)=e^{$(a1)t} \\ \\ \\ v(t)=$(a1)e^{$(a1)t}"),15,:black,:left)))
end	

# ╔═╡ 523b78c2-02b2-4736-8f89-2f0430a88b02
md"""
α $(@bind a2 Slider(-1.0:0.1:-0.1,default=-0.5;show_value=true)) \
"""

# ╔═╡ b389d61c-95e3-488b-887d-86edc2d1da9b
begin
	@bind t0_3 Clock(0.1,true,false,floor(Int,-33/a2),false)
end

# ╔═╡ dd520bf5-dd7c-4c15-930b-bf7c4c276111
begin
	t03 = (t0_3-1)*0.1
	s03 = exp(a2*t03)
	v03 = a2*exp(a2*t03)
	plot_velocity(t03,s03,v03,-0.1,1.15;centerpos=1.0,voffset=-0.01)
	annotate!((0.0,-0.3,text(latexstring("s(t)=e^{$(a2)t} \\ \\ \\ v(t)=$(a2)e^{$(a2)t}"),15,:black,:left)))
end	

# ╔═╡ 0d5cca05-aaa7-47ce-91b5-1ede5f1b8dde
begin
	@bind t0_4 Clock(0.1,true,false,61,true)
end

# ╔═╡ 6770a7ed-aeb2-40cd-9ec0-c6a48cde1ee8
begin
	tl = 0:pi/100:2*pi
	t04 = (t0_4-1)*pi/30
	s04 = exp(im*t04)
	v04 = im*exp(im*t04)
	tlabel4 = latexstring("t=$(round(t04,digits=2))")
	pp4 = plot_complexplane(-3, 3, -2, 2; arrow_to=s04,width=800,height=600)
	plot!(pp4, [real(s04),real(s04+v04)],[imag(s04),imag(s04+v04)],c=:blue,lw=3, arrow=true)
	scatter!(pp4,[real(s04)],[imag(s04)],c=:gray,msw=1)
	plot!(pp4,cos.(tl),sin.(tl),ls=:dash)
	annotate!(pp4,(0.5,1.8,text(tlabel4,12,:black)))
	annotate!((-2.8,-1.8,text(latexstring("s(t)=e^{it} \\ \\ \\ v(t)=ie^{it}"),15,:black,:left)))
end

# ╔═╡ 18267cb1-99b8-4ed4-8558-1de0bdae4795
html"""
<style>
main {
    max-width: 1000px;
}
input[type*="range"] {
	width: 25%;
}
</style>
"""

# ╔═╡ Cell order:
# ╟─240f065d-067b-4888-b9db-0dcfae91b81d
# ╟─b3488a41-98c0-4816-91e8-8a9d867689fd
# ╟─a321b881-11e7-408c-a71e-8ba2ddb632ff
# ╟─3bfe1b5b-0aa0-4171-9469-99401c09afda
# ╟─3870562d-e580-4f5d-83d5-804da16432ff
# ╟─667886da-feaf-4bdc-b2d7-9860ce651b8a
# ╟─b389d61c-95e3-488b-887d-86edc2d1da9b
# ╟─dd520bf5-dd7c-4c15-930b-bf7c4c276111
# ╟─523b78c2-02b2-4736-8f89-2f0430a88b02
# ╟─0d5cca05-aaa7-47ce-91b5-1ede5f1b8dde
# ╠═6770a7ed-aeb2-40cd-9ec0-c6a48cde1ee8
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╠═f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
