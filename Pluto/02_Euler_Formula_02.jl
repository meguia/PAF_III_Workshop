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

On the number line, we can draw an arrow from $0$ to $s(t)$ to indicate the position (red)

The velocity $v(t)$ is the rate of change of that distance at time t and it can also be indicade by an arrow (blue)

Let start with the simples case: constant velocity

$s(t) = s(0) + vt$ 

where $s(0)$ is the position at the initial time $t=0$

"""

# ╔═╡ e5e55559-3aab-4fd4-b7a2-ad3a512bb376
md"""
v $(@bind v01 Slider(-1.0:0.1:1.0,default=1.0;show_value=true)) \
"""

# ╔═╡ b3488a41-98c0-4816-91e8-8a9d867689fd
begin
	@bind t0_1 Clock(0.1,true,false,floor(Int,50/(abs(v01)+0.1)),false)
end

# ╔═╡ a321b881-11e7-408c-a71e-8ba2ddb632ff
begin
	s0 = 1.0
	t01 = (t0_1-1)*0.1
	s01 = s0+t01*v01
	plot_velocity(t01,s01,v01,min(s01+v01,-2),max(s01+v01,7))
	annotate!((0.0,-0.3,text(latexstring("s(t)=1+vt"),15,:black,:left)))
end	

# ╔═╡ cb996baa-8ee5-4dd9-9d61-463ae320eafe
md"""
### Exponential growth

There is a unique function of time whose instantaneous velocity equals its position.
It is the exponential.

$s(t) = e^t$

$v(t)= s^{\prime}(t) = e^t$

At $t=0$, $e^0=1$. Position is $1$. Velocity is also $1$. 

They always match in length and direction. This property characterizes the exponential.

More generally, if we set a constant rate $\alpha$:

$s(t)=e^{\alpha t}$ 

then the velocityt is proportional to the position

$v(t)=\alpha e^{\alpha t} = \alpha s(t)$

The motion growths exponentially.

"""

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

# ╔═╡ ef4720b7-dee8-4617-b121-1e939b3061ad
md"""
### Exponential decay (negative rate)

If we now choose $a<0$ the velocity points opposite to the position on the line.
The motion shrinks towards $0$ with an exponential envelope.
"""

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

# ╔═╡ 976c393e-a42e-44fc-8029-932a43565a04
md"""
### Imaginary exponent. Rotation in complex plane

Growth and decay (stretching and squishing) can be described with real numbers and take place in the line.

What happen if we generalize to the complex domain?

We start by the simplest example:

$s(t) = e^{it}$

$v(t) = s^{\prime}(t) = ie^{it} = i s(t)$

At $t=0$: $s(t) = 1$ and $v(t) = i$, then the "velocity" is pointing $90$ degrees, out of the line in the complex plane.
At all times $v(t)=is(t)$ and multiplying by $i$ corresponds to a rotation of quarter of turn in the complex plane. So the velocity is always perpendicular to the position. Therefore the motion takes place in the **unit circle** (in green), courterclockwise at constant speed. At any time the angle in radians is equal to the elapsed time. The real part of the position is $cos(t)$ and the imaginary part is $sin(t)$. 
"""

# ╔═╡ 0d5cca05-aaa7-47ce-91b5-1ede5f1b8dde
begin
	@bind t0_4 Clock(0.1,true,false,61,true)
end

# ╔═╡ 6770a7ed-aeb2-40cd-9ec0-c6a48cde1ee8
begin
	t04 = (t0_4-1)*pi/30
	plot_velocity_complex(t04,im,3,2)
end

# ╔═╡ 3416f2c9-f202-44c1-b46f-8fc127eb05cd
md"""
### Complex exponent. Rotation and stretching/squeezing

We now generalize to a complex rate $z=\alpha + i\omega$

$s(t) = e^{zt} = e^{(\alpha+i\omega)t} = e^{\alpha t}e^{i\omega t}$

$v(t) = s^{\prime}(t) = z s(t)$

At $t=0$: $s(t)=1$ and $v(t)=\alpha + i\omega$. 

The velocity has a real part that is radial: inward if $\alpha<0$ or outward (if $\alpha>0$), relative to the unit circle.
The real part will be responsible of the stretching/squeezing in the complex plane. 
The imaginary part is tangential and corresponds to a pure rotation (counterclockwise if $\omega$ is positive). 

It is more simple to describe the motion in the polar form $s(t)=r(t)e^{\theta(t)}$

The motion will take place in a spiral (inward if $\alpha<0$ and outward if $\alpha>0$). The radius of the position will be at any moment:

$r(t)=e^{\alpha t}$

The imaginary part $\omega$ sets the angular velocity of the motion (radians per second). The angle will be always

$\theta(t) = \omega t$

"""

# ╔═╡ 9981a256-a8a2-4c3d-94ce-c4a6b8e4cbe8
md"""
ω $(@bind ω Slider(0.7:0.1:2.0,default=1.0;show_value=true)) \
α $(@bind a3 Slider(-0.3:0.1:0.3,default=0.0;show_value=true)) \
"""

# ╔═╡ 8088bb52-c94d-4816-b0cd-1cb62158b698
begin
	@bind t0_5 Clock(0.1,true,false,floor(Int,120/ω)+ceil(Int,abs(a3)),false)
end

# ╔═╡ 2d9a9e10-5f64-409f-82aa-bfe8442e9c02
begin
	t05 = (t0_5-1)*pi/30
	plot_velocity_complex(t05,a3+ω*im,3,2;drawpath=true)
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
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─240f065d-067b-4888-b9db-0dcfae91b81d
# ╟─b3488a41-98c0-4816-91e8-8a9d867689fd
# ╟─a321b881-11e7-408c-a71e-8ba2ddb632ff
# ╟─e5e55559-3aab-4fd4-b7a2-ad3a512bb376
# ╟─cb996baa-8ee5-4dd9-9d61-463ae320eafe
# ╟─3bfe1b5b-0aa0-4171-9469-99401c09afda
# ╟─3870562d-e580-4f5d-83d5-804da16432ff
# ╟─667886da-feaf-4bdc-b2d7-9860ce651b8a
# ╟─b389d61c-95e3-488b-887d-86edc2d1da9b
# ╟─ef4720b7-dee8-4617-b121-1e939b3061ad
# ╟─dd520bf5-dd7c-4c15-930b-bf7c4c276111
# ╟─523b78c2-02b2-4736-8f89-2f0430a88b02
# ╟─976c393e-a42e-44fc-8029-932a43565a04
# ╟─0d5cca05-aaa7-47ce-91b5-1ede5f1b8dde
# ╟─6770a7ed-aeb2-40cd-9ec0-c6a48cde1ee8
# ╟─3416f2c9-f202-44c1-b46f-8fc127eb05cd
# ╟─8088bb52-c94d-4816-b0cd-1cb62158b698
# ╟─2d9a9e10-5f64-409f-82aa-bfe8442e9c02
# ╟─9981a256-a8a2-4c3d-94ce-c4a6b8e4cbe8
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
