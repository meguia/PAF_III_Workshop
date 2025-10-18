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

Any periodic motion can be choreographed by stacking several constant-speed rotations (frequencies at multiples of a base rate). 

The set of radii & starting angles = the spectrum (the ingredient list). 

Any smooth curve can be approximated to arbitrary accuracy with a sufficient number of epicycles "

"""

# ╔═╡ 263affc0-a928-4d6f-97e9-48aa6126d1f3
@bind t_1 Clock(0.1,true,false,401,false)

# ╔═╡ 1f093de0-9501-11ef-30d2-4f854ecfb2e5


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
	wavwrite(Int.(trunc.(0.9*snd/maximum(abs.(snd))*2^15)), "audio.wav", Fs=fs, nbits=16)
end

# ╔═╡ 73860e95-58ae-432c-abf4-99a0dbe2429c
begin
	ns = Int(floor(fs*wdw/1000))
	plot(1000*(1:ns)/fs,snd[1:ns]/maximum(abs.(snd)),c=:blue,size=(1200,300),label="",xlabel="time(ms)",xlims=(0,wdw),grid=true)
	for n=1:7
		plot!(1000*(1:ns)/fs,components[1:ns,n]/maximum(abs.(snd)),c=:gray,label="")
	end	
	plot!([0,wdw],[0,0],c=:black,ls=:dash,label="")
end	

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
	p1, p2 = plot_ntones(t1,Amps[1,:],frq[1,:],ϕs[1,:],Am)
	plot(p1,p2,layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],size=(1200,400))
end	

# ╔═╡ Cell order:
# ╟─83f8450d-3225-4f37-ba5d-9f510cf0d497
# ╟─f6138348-b17a-40a1-95d7-056191b7a852
# ╟─350c15e0-09a8-4c98-98cf-02069d7ce5b3
# ╟─73860e95-58ae-432c-abf4-99a0dbe2429c
# ╟─263affc0-a928-4d6f-97e9-48aa6126d1f3
# ╟─a2f57914-6a31-4e3b-ab6d-2dadfc76938d
# ╟─c36b7f32-cc93-41ae-88d8-dfc5fb61eaec
# ╟─624a94c0-f33e-402d-9401-f7d0c90cb3b0
# ╟─21c750d4-9bc2-4002-a8c8-606856479415
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─b708f59c-905d-45d8-8a48-70b3bb534af5
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─234a88c7-314b-419e-9092-7d00be674b2b
