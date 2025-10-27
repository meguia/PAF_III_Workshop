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
	import Pkg; Pkg.activate(Base.current_project()); Pkg.instantiate();
	using Plots, PlutoUI, LaTeXStrings, PlutoEditorColorThemes, Latexify, Measures, ProjectRoot, WAV
end

# ╔═╡ f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╠═╡ show_logs = false
include("../iii_utils.jl");

# ╔═╡ 83f8450d-3225-4f37-ba5d-9f510cf0d497
md"""
# Periodic oscillations

The Oscillation of angular frequency $\omega=1$, amplitude (or radius) $A_1$ and initial phase $\phi_1$:

$E_1(t) = A_1e^{i\phi_1}e^{it}$

is periodic with period $T=2\pi$. That means that it repeats itself after an arbitrary numbers of periods $nT$ with $n \in \mathbb{Z}$

$E_1(t+nT) = E_1(t+n2\pi) = E_1(t)$

We will consider all elementary oscillations of angular frequency $\omega = k$ with $k \in \mathbb{Z}$

$E_k(t) = A_ke^{i\phi_k}e^{ikt}$

All these elementary oscillations have their "own" period $T=2\pi/k$ but they 
also have period $T=2\pi$, since:

$E_k(t+n2\pi) = A_ke^{i\phi_k}e^{ik(t+n2\pi)} = A_ke^{i\phi_k}e^{ikt}e^{n2\pi} = A_ke^{i\phi_k}e^{ikt} = E_k(t)$ 

because $e^{n2\pi}$ only "adds" $n$ full turns and is equal to 1.

Therefore, if we add an arbitrary number of elementary oscillations $E_k(t)$ that are periodic in $2\pi$, the result will also be periodic in $2\pi$.

"""

# ╔═╡ 263affc0-a928-4d6f-97e9-48aa6126d1f3
@bind t_1 Clock(0.1,true,false,401,false)

# ╔═╡ f795c84a-6531-4ef5-998c-b71f0be9918c
md"""
The set of radii (amplitudes) and starting angles (phases) it is called the spectrum of s(t) (the ingredient list). 
and can be represented in a graph of amplitud vs frequency and phase vs frequency
"""

# ╔═╡ e5569cd6-5e04-421d-bc96-bbdd08b7f94f
md"""
## Fourier bold claim:

"Every periodic function is (exactly or to arbitrary accuracy) a sum of constant-frequency oscillations (elementary oscillations) with uniquely determined amplitudes and phases."

Ptolomeus trick:

"Any smooth curve in the plane can be approximated to arbitrary accuracy with a sufficient number of epicycles"


"""

# ╔═╡ a9392111-1aa7-46a4-9d54-8a12c4bc91fa
md"""
## Turning the oscillations into sound

We can turn these oscillations into sound by scaling the frequency into the audible range. Here $\f_0$ stands for the **base frequency**, the inverse of the period $T$.
"""

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

# ╔═╡ 350c15e0-09a8-4c98-98cf-02069d7ce5b3
md"""
f₀ = $(@bind f0 Slider(100:440,default=220;show_value=true)) $sp 
window (ms) = $sp $(@bind wdw Slider(5:100,default=20;show_value=true)) $sp
$(@bind play CounterButton("Play"))
"""

# ╔═╡ 1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╠═╡ disabled = true
#=╠═╡
let 
	play 
	wavplay("audio.wav")
end
  ╠═╡ =#

# ╔═╡ 21c750d4-9bc2-4002-a8c8-606856479415
par_widget = @bind par PlutoUI.combine() do Child
	md"""
	ω = 1 : $sp A₁ = $(Child("A1", Slider(0:0.02:1,default=1.0;show_value=true))) $sp
	ϕ₁  = $(Child("ϕ1", Slider(0:pi/12:2*pi,default=0.0;show_value=x->round(x, digits=2))))\
	ω = 2 : $sp A₂ = $(Child("A2", Slider(0:0.02:1,default=0.0;show_value=true))) $sp
	ϕ₂ = $(Child("ϕ2", Slider(0:pi/12:2*pi,default=0.0;show_value=x->round(x, digits=2)))) \
	ω = 3 : $sp A₃ = $(Child("A3", Slider(0:0.02:1,default=0.0;show_value=true))) $sp
	ϕ₃ = $(Child("ϕ3", Slider(0:pi/12:2*pi,default=0.0;show_value=x->round(x, digits=2)))) \
	ω = 4 : $sp A₄ = $(Child("A4", Slider(0:0.02:1,default=0.0;show_value=true))) $sp
	ϕ₄ = $(Child("ϕ4", Slider(0:pi/12:2*pi,default=0.0;show_value=x->round(x, digits=2)))) \
	ω = 5 : $sp A₅ = $(Child("A5", Slider(0:0.02:1,default=0.0;show_value=true))) $sp
	ϕ₅ = $(Child("ϕ5", Slider(0:pi/12:2*pi,default=0.0;show_value=x->round(x, digits=2)))) \
	ω = 6 : $sp A₆ = $(Child("A6", Slider(0:0.02:1,default=0.0;show_value=true))) $sp
	ϕ₆ = $(Child("ϕ6", Slider(0:pi/12:2*pi,default=0.0;show_value=x->round(x, digits=2)))) \
	ω = 7 : $sp A₇ = $(Child("A7", Slider(0:0.02:1,default=0.0;show_value=true))) $sp
	ϕ₇ = $(Child("ϕ7", Slider(0:pi/12:2*pi,default=0.0;show_value=x->round(x, digits=2)))) 
	"""
end;

# ╔═╡ f6138348-b17a-40a1-95d7-056191b7a852
par_widget

# ╔═╡ 624a94c0-f33e-402d-9401-f7d0c90cb3b0
begin
	fs = 44100
	dt = 1/fs
	ts = collect(0:dt:2)
	Amps=[par.A1 par.A2 par.A3 par.A4 par.A5 par.A6 par.A7]
	ωs = [1 2 3 4 5 6 7]*2*pi*f0
	ϕs = [par.ϕ1 par.ϕ2 par.ϕ3 par.ϕ4 par.ϕ5 par.ϕ6 par.ϕ7]
	components = Amps.*sin.(ωs.*ts .+ ϕs)
	snd = sum(components,dims=2)
end;

# ╔═╡ a2f57914-6a31-4e3b-ab6d-2dadfc76938d
begin
	t1 = mod(t_1-0.99,400)*(4*pi)/400
	frq = [1 2 3 4 5 6 7]
	pps = plot_fasors(t1,Amps[1,:],frq[1,:],ϕs[1,:],1.05)
	plot(pps...,layout=(1,7),size=(1200,190),left_margin=[-10mm -10mm])
end	

# ╔═╡ c36b7f32-cc93-41ae-88d8-dfc5fb61eaec
begin
	Am = 6.0
	tlabel = latexstring("t=$(round(t1,digits=2))")
	p1, p2 = plot_ntones(t1,Amps[1,:],frq[1,:],ϕs[1,:],Am;plot_trace=true)
	plot(p1,p2,layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],bottom_margin=[7mm 7mm],size=(1200,430))
end	

# ╔═╡ 26916ca7-2996-4256-bc29-c962b68308ab
begin
	p1b = plot(bar(frq[1,:],Amps[1,:],bar_width = 0.2, c=:red, label=""), xlabel=latexstring("\\omega"),xguidefontsize=18,ylabel=latexstring("Amplitude"),yguidefontsize=18)
	p2b = plot(bar(frq[1,:],ϕs[1,:],bar_width = 0.2,c=:blue, label=""), xlabel=latexstring("\\omega"),xguidefontsize=18,ylabel=latexstring("Phase"),yguidefontsize=18)
	plot(p1b,p2b,layout=(1,2),left_margin=[10mm 10mm],bottom_margin=[7mm 7mm],size=(1200,400))
end	

# ╔═╡ 73860e95-58ae-432c-abf4-99a0dbe2429c
begin
	ns = Int(floor(fs*wdw/1000))
	plot(1000*(1:ns)/fs,snd[1:ns]/maximum(abs.(snd)),c=:blue,size=(1200,300),label="",xlabel="time(ms)",xlims=(0,wdw),grid=true)
	for n=1:7
		plot!(1000*(1:ns)/fs,components[1:ns,n]/maximum(abs.(snd)),c=:gray,label="")
	end	
	plot!([0,wdw],[0,0],c=:black,ls=:dash,label="",bottom_margin=7mm)
end	

# ╔═╡ e969de73-6dea-45e1-ae02-8f2c91276902
# ╠═╡ disabled = true
#=╠═╡
wavwrite(Int.(trunc.(0.9*snd/maximum(abs.(snd))*2^15)), "audio.wav", Fs=fs, nbits=16)
  ╠═╡ =#

# ╔═╡ Cell order:
# ╟─83f8450d-3225-4f37-ba5d-9f510cf0d497
# ╟─263affc0-a928-4d6f-97e9-48aa6126d1f3
# ╟─f6138348-b17a-40a1-95d7-056191b7a852
# ╟─a2f57914-6a31-4e3b-ab6d-2dadfc76938d
# ╟─c36b7f32-cc93-41ae-88d8-dfc5fb61eaec
# ╟─f795c84a-6531-4ef5-998c-b71f0be9918c
# ╟─26916ca7-2996-4256-bc29-c962b68308ab
# ╟─e5569cd6-5e04-421d-bc96-bbdd08b7f94f
# ╟─a9392111-1aa7-46a4-9d54-8a12c4bc91fa
# ╟─350c15e0-09a8-4c98-98cf-02069d7ce5b3
# ╟─73860e95-58ae-432c-abf4-99a0dbe2429c
# ╟─624a94c0-f33e-402d-9401-f7d0c90cb3b0
# ╟─e969de73-6dea-45e1-ae02-8f2c91276902
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─21c750d4-9bc2-4002-a8c8-606856479415
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─b708f59c-905d-45d8-8a48-70b3bb534af5
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─234a88c7-314b-419e-9092-7d00be674b2b
