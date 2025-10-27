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
# Oscillations 

## Elementary Oscillations (Pure Tones)

Elementary Oscillations can be expressed as a function of time as

$s(t) = A e^{i\omega t}$

This is a complex function of radius $A$ and angle $\theta(t) = \omega t$. In the context of the study of Oscillations this angle is also called **phase**

This can be seen represented as a point rotating at constant angular speed ($\omega$) counterclockwise on a circle of radius $A$ on the complex plane.
$\omega$ is called the **angular frequency** and expresses how many radians per second the phase $\theta$ advances.

The real part of this function is

$Re(s(t)) = A \cos(\omega t)$

And it can be seen as the "shadow" on the ground of the moving point.
And the imaginary part is the "shadow" on the wall:

$Im(s(t)) = A \sin(\omega t)$

They are periodic with period $T=2\pi/\omega$, since:

$s(t+T)=s(t+2\pi/\omega)=A e^{i\omega (t+2\pi/\omega)} = A e^{i\omega t}e^{i 2\pi} = A e^{i\omega t}1 = s(t)$

"""

# ╔═╡ 8ba30273-6d98-439f-910c-f0bd589d543d
begin
	@bind t_1 Clock(0.1,true,false,401,true)
end

# ╔═╡ a0af0068-1933-4760-9fc1-c7959b3f74b8
md"""
A $(@bind Amp Slider(0:0.01:2,default=1.0;show_value=true)) \
ω $(@bind ω Slider(1.0:0.1:5.0,default=1.0;show_value=true))
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
Plotting the Real and Imaginary parts
"""

# ╔═╡ 1fe438b6-0208-48ac-86bf-e02da1ba4017
md"""
## Elementary Oscillations with initial phase

Later we will combine Elementary Oscillations and it will be useful to assign the an initial angle for $t=0$, or **initial phase**.

This can be achieved by adding a constant phase $\phi$ to the exponent:

$s(t) = Ae^{i(\omega t + \phi)}$

Or by using a complex amplitude $C=Ae^{i\phi}$ that incorporates the phase:

$s(t) = Ce^{i\omega t} = Ae^{i\phi} e^{i\omega t}$

"""

# ╔═╡ 7e060b26-118c-445b-be90-8034517ec277
md"""
## Sum of Elementary Oscillations

Three elementary oscillations with angular speeds $\omega = 1$, $\omega = 2$, $\omega = 3$ rad/s.

$s(t) = A_1 e^{i\phi_1}e^{it} + A_2 e^{i\phi_2}e^{i2t} + A_3 e^{i\phi_3}e^{i3t}$

Each term ($k=1, 2, 3$) is a rotating arrow with its own radius $A_k$ and initial phase $\phi_k$.

The left panel shows the sum in the complex plane. The right panel shows its projection in the vertical axis as a function of time (waveform).

Amplitudes control the weight of each oscillation (or component).

Phases control the relative alignment of the components and change the waveform.

Changes in $A_k$ and $\phi_k$ don't affect the base period, that stays $2\pi$

"""

# ╔═╡ c8bf120f-b2dc-4e90-90e7-12d2fdb1c660
@bind t_2 Clock(0.1,true,false,401, true)

# ╔═╡ e23c472d-fcfd-4183-8849-11b14f8aeaca
md"""
## Making the Oscillation Real
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
ω = 1 : $sp A₁ = $(@bind A1 Slider(0:0.02:1,default=1.0;show_value=true)) $sp
ϕ₁  = $(@bind ϕ1 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω = 2 : $sp  A₂ = $(@bind A2 Slider(0:0.02:1,default=0.0;show_value=true)) $sp
ϕ₂ = $(@bind ϕ2 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω = 3 : $sp A₃ = $(@bind A3 Slider(0:0.02:1,default=0.0;show_value=true)) $sp
ϕ₃ = $(@bind ϕ3 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
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
ω = 1 : $sp A₁ = $(@bind A1p Slider(0:0.02:1,default=1.0;show_value=true)) $sp
ϕ₁  = $(@bind ϕ1p Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω = -1 : $sp  A₋₁ = $(@bind A1n Slider(0:0.02:1,default=0.0;show_value=true)) $sp
ϕ₋₁ = $(@bind ϕ1n Slider(0:0.02:6.28,default=0.0;show_value=true)) \
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
