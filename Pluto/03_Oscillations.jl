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
using Plots, PlutoUI, LaTeXStrings, PlutoEditorColorThemes, Latexify, Measures, ProjectRoot, WAV

# ╔═╡ f701ab61-2512-4f2a-a182-a6f2b23e0bd2
include("../iii_utils.jl");

# ╔═╡ 83f8450d-3225-4f37-ba5d-9f510cf0d497
md"""
# Elementary Oscillations (Pure Tones)

Elementary Oscillations (Pure Tones) can be expressed as a function of time as

$s(t) = A e^{i\omega t}$

This is a complex function of radius $A$ and angle $\theta(t) = \omega t$. In the context of the study of Oscillations this angle is also called **phase**

This can be seen represented as a point moving at constant speed ($\omega$ radians per second) counterclockwise on a circle of radius $A$ on the complex plane.

The real part of this function is

$Re(s(t)) = A \cos(\omega t)$

And it can be seen as the "shadow" on the ground of the moving point.
And the imaginary part is the "shadow" on the wall:

$Im(s(t)) = A \sin(\omega t)$

Elementary Oscillations are eigenfunctions of time-shifts: Shifting only re-phases them.

As a consequence any time-invariant linear process (a filter) make no change on PT

A pure tone is that constant-rate U(1) rotation (the circle group).

"""

# ╔═╡ 8ba30273-6d98-439f-910c-f0bd589d543d
begin
	@bind t_1 Clock(0.1,true,false,101,true)
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
	p1 = plot([-2,2],[0,0],ls=:dash,c=:gray,label="",xlims=(-2,2),ylims=(-2,2))
	plot!([0,0],[-2,2],ls=:dash,c=:gray,label="",xlabel="",ylabel="Amplitude")
	plot!(Amp*cos.(0:pi/20:2*pi),Amp*sin.(0:pi/20:2*pi),ls=:dash,c=:green,label="")
	plot!([0,x1],[y1,y1],ls=:dash,c=:blue,label="")
	plot!([0,x1],[0,y1],c=:red,label="")
	plot!([0,0],[0,y1],c=:blue,label="")
	plot!([0,2],[y1,y1],ls=:dash,c=:blue,label="")
	scatter!([x1],[y1],c=:red,ms=5,label="")
	scatter!([0],[y1],c=:blue,ms=5,label="")
	t1b = (0:pi/50:2*pi)
	p2 = plot(t1b,Amp*sin.(ω*t1b),label="",ls=:dash,c=:green,ylims=(-2,2),title=latexify("t=$(round(t1,digits=2))"))
	plot!([0,2*pi],[0,0],ls=:dash,c=:black,label="")
	scatter!([t1],[y1],c=:blue,ms=5,label="",xlims=(0,2*pi))
	plot!([0,t1],[y1,y1],c=:blue,ls=:dash,label="")
	plot(p1,p2, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],size=(1200,400))
end	

# ╔═╡ 7e060b26-118c-445b-be90-8034517ec277
md"""
# Sum of Oscillations

Three elementary oscillations with angular speeds $\omega = 1$, $\omega = 2$, $\omega = 3$ rad/s.

$s(t) = A_1 e^{i(t+\phi_1)} + A_2 e^{i(2t+\phi_2)} + A_3 e^{i(3t+\phi_3)}$

Each term ($k=1, 2, 3$) is a rotating arrow with its own radius $A_k$ and starting angle $\phi_k$.

The left panel shows the sum in the complex plane. The right panel shows its projection in the vertical axis as a function of time (waveform).

Amplitudes control the weight of each oscillation (or component).

Phases control the relative alignment of the components and change the waveform.

Changes in $A_k$ and $\phi_k$ don't affect the base period, that stays $2\pi$

"""

# ╔═╡ c8bf120f-b2dc-4e90-90e7-12d2fdb1c660
@bind t_2 Clock(0.1,true,false,401,false)

# ╔═╡ 0e34247d-671a-46b3-be5b-3f4545d848f0
md"""
ω = 1 | A₁ = $(@bind A1 Slider(0:0.02:2,default=1.0;show_value=true)) 
ϕ₁  = $(@bind ϕ1 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω = 2 | A₂ = $(@bind A2 Slider(0:0.02:2,default=1.0;show_value=true)) 
ϕ₂ = $(@bind ϕ2 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω = 3 | A₃ = $(@bind A3 Slider(0:0.02:2,default=1.0;show_value=true)) 
ϕ₃ = $(@bind ϕ3 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
"""

# ╔═╡ 52f0eb33-18b6-452d-a250-65a54d96080f
begin
	t2 = (t_2-1)*(4*pi)/400
	Amps = [A1, A2, A3]
	ωs = [1,2,3]
	ϕs = [ϕ1,ϕ2,ϕ3]
	xs = Amps.*cos.(ωs*t2 .+ ϕs)
	ys = Amps.*sin.(ωs*t2 .+ ϕs)
	Amax = 6
	p1b = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(-Amax,Amax))
	plot!([0,0],[-Amax,Amax],ls=:dash,c=:gray,label="",xlabel="",ylabel="Amplitude")
	plot!([0,sum(xs)],[sum(ys),sum(ys)],ls=:dash,c=:blue,label="")
	plot!([0,xs[1]],[0,ys[1]],c=:red,label="")
	plot!([xs[1],xs[1]+xs[2]],[ys[1],ys[1]+ys[2]],c=:red,label="")
	plot!([xs[1]+xs[2],sum(xs)],[ys[1]+ys[2],sum(ys)],c=:red,label="")
	plot!([0,0],[0,sum(ys)],c=:blue,label="")
	plot!([0,Amax],[sum(ys),sum(ys)],ls=:dash,c=:blue,label="")
	plot!(Amps[1]*cos.(0:pi/20:2*pi),Amps[1]*sin.(0:pi/20:2*pi),c=:green,label="")
	plot!(xs[1].+Amps[2]*cos.(0:pi/20:2*pi),ys[1].+Amps[2]*sin.(0:pi/20:2*pi),c=:green,label="")
	plot!(xs[2].+xs[1].+Amps[3]*cos.(0:pi/20:2*pi),ys[1].+ys[2].+Amps[3]*sin.(0:pi/20:2*pi),c=:green,label="")
	scatter!([xs[1]],[ys[1]],c=:red,ms=4,alpha=0.6,label="")
	scatter!([xs[1]+xs[2]],[ys[1]+ys[2]],c=:red,ms=4,alpha=0.6,label="")
	scatter!([sum(xs)],[sum(ys)],c=:red,ms=5,label="")
	scatter!([0],[sum(ys)],c=:blue,ms=5,label="")
	t2b = (0:pi/50:4*pi)
	p2b = plot(t2b,sum(Amps'.*sin.(t2b*ωs' .+ ϕs'),dims=2),label="",c=:blue,ylims=(-Amax,Amax))
	plot!([0,4*pi],[0,0],ls=:dash,c=:black,label="",title=latexify("t=$(round(t2,digits=2))"))
	scatter!([t2],[sum(ys)],c=:blue,ms=5,label="",xlims=(0,4*pi))
	plot!([0,t2],[sum(ys),sum(ys)],c=:blue,ls=:dash,label="")
	plot(p1b,p2b, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],size=(1200,400))
end	

# ╔═╡ 09a6bcc2-4a05-435f-92d0-b78dc7a5c321
begin
	p3a = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(-16,6))
	plot!([0,0],[-16,Amax],ls=:dash,c=:gray,label="",xlabel="",ylabel="Amplitude")
	plot!([0,sum(xs)],[sum(ys),sum(ys)],ls=:dash,c=:blue,label="")
	plot!([0,xs[1]],[0,ys[1]],c=:red,label="")
	plot!([0,Amax],[sum(ys),sum(ys)],ls=:dash,c=:blue,label="")
	plot!([xs[1],xs[1]+xs[2]],[ys[1],ys[1]+ys[2]],c=:red,label="")
	plot!([xs[1]+xs[2],sum(xs)],[ys[1]+ys[2],sum(ys)],c=:red,label="")
	plot!([0,0],[0,sum(ys)],c=:blue,label="")
	plot!(Amps[1]*cos.(0:pi/20:2*pi),Amps[1]*sin.(0:pi/20:2*pi),c=:green,label="")
	plot!(xs[1].+Amps[2]*cos.(0:pi/20:2*pi),ys[1].+Amps[2]*sin.(0:pi/20:2*pi),c=:green,label="")
	plot!(xs[2].+xs[1].+Amps[3]*cos.(0:pi/20:2*pi),ys[1].+ys[2].+Amps[3]*sin.(0:pi/20:2*pi),c=:green,label="")
	scatter!([xs[1]],[ys[1]],c=:red,ms=4,alpha=0.6,label="")
	scatter!([xs[1]+xs[2]],[ys[1]+ys[2]],c=:red,ms=4,alpha=0.6,label="")
	scatter!([sum(xs)],[sum(ys)],c=:red,ms=5,label="")
	scatter!([0],[sum(ys)],c=:blue,ms=5,label="")
	for n=1:3
		offset = -2-4*n
		plot!([-Amax,Amax],[offset,offset],ls=:dash,c=:gray,label="")
		plot!(Amps[n]*cos.(0:pi/20:2*pi),Amps[n]*sin.(0:pi/20:2*pi).+offset,c=:green,label="")
		plot!([0,xs[n]],[0,ys[n]].+offset,c=:red,label="")
		scatter!([xs[n]],[ys[n]].+offset,c=:red,ms=4,label="")
		plot!([0,0],[0,ys[n]].+offset,c=:green,label="")
		scatter!([0],[ys[n]+offset],c=:green,ms=5,label="")
		plot!([0,Amax],[ys[n],ys[n]].+offset,ls=:dash,c=:green,label="")
		plot!([0,xs[n]],[ys[n],ys[n]].+offset,ls=:dash,c=:green,label="")
	end	
	p3b = plot(t2b,sum(Amps'.*sin.(t2b*ωs' .+ ϕs'),dims=2),label="",c=:blue,xlims=(0,4*pi))
	scatter!([t2],[sum(ys)],c=:blue,ms=5,label="",ylims=(-16,6))
	for n=0:3
		if n>0
			offset = -2-4*n
			plot!([t2,t2],[0,ys[n]].+offset,c=:green,label="")
			plot!([0,4*pi],[0,0].+offset,ls=:dash,c=:black,label="")
			plot!([0,t2],[ys[n],ys[n]].+offset,c=:green,ls=:dash,label="")
		else
			plot!([0,4*pi],[0,0],ls=:dash,c=:black,label="")
			plot!([t2,t2],[0,sum(ys)],c=:blue,label="")
			plot!([0,t2],[sum(ys),sum(ys)],c=:blue,ls=:dash,label="")
		end	
	end	
	plot!(t2b,Amps'.*sin.(t2b*ωs' .+ ϕs').+[-6,-10,-14]',c=:green,label="")
	scatter!([t2,t2,t2],ys.+[-6,-10,-14],c=:green,ms=5,label="")
	plot(p3a,p3b, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],size=(1200,700))
end	

# ╔═╡ 2213d433-ba9d-442d-b783-c63a1b1aeb48
@bind play CounterButton("Play")

# ╔═╡ 624a94c0-f33e-402d-9401-f7d0c90cb3b0
begin
	fs = 44100
	dt = 1/fs
	ts = collect(0:dt:2)
	fbase = 2*pi*220
	snd = Amps[1]*sin.(ωs[1]*fbase*ts .+ ϕs[1])+Amps[2]*sin.(ωs[2]*fbase*ts .+ ϕs[2])+Amps[3]*sin.(ωs[3]*fbase*ts .+ ϕs[3])
	wavwrite(Int.(trunc.(0.9*snd/maximum(abs.(snd))*2^15)), "audio.wav", Fs=fs, nbits=16)
end

# ╔═╡ 73860e95-58ae-432c-abf4-99a0dbe2429c
plot((1:500)/fs,snd[1:500]/maximum(abs.(snd)),size=(1200,300),label="")

# ╔═╡ b708f59c-905d-45d8-8a48-70b3bb534af5
begin
	# this is a comment
	stylefile = joinpath(@projectroot,"Pluto","light_33.css")
	PlutoEditorColorThemes.setcolortheme!(stylefile)
end

# ╔═╡ fddf6b7c-8d5d-4a5e-8adf-2706e1605dcd
let 
	play
	wavplay("audio.wav")
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
# ╟─83f8450d-3225-4f37-ba5d-9f510cf0d497
# ╟─8ba30273-6d98-439f-910c-f0bd589d543d
# ╟─a0af0068-1933-4760-9fc1-c7959b3f74b8
# ╟─50f48ea1-228c-493d-9d55-a2ada49248b7
# ╟─7e060b26-118c-445b-be90-8034517ec277
# ╟─c8bf120f-b2dc-4e90-90e7-12d2fdb1c660
# ╟─0e34247d-671a-46b3-be5b-3f4545d848f0
# ╟─52f0eb33-18b6-452d-a250-65a54d96080f
# ╟─09a6bcc2-4a05-435f-92d0-b78dc7a5c321
# ╟─2213d433-ba9d-442d-b783-c63a1b1aeb48
# ╟─73860e95-58ae-432c-abf4-99a0dbe2429c
# ╠═624a94c0-f33e-402d-9401-f7d0c90cb3b0
# ╠═b708f59c-905d-45d8-8a48-70b3bb534af5
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─fddf6b7c-8d5d-4a5e-8adf-2706e1605dcd
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
