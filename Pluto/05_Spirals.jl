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
	import Pkg; Pkg.activate(Base.current_project()); Pkg.instantiate();
	using Plots, PlutoUI, LaTeXStrings, PlutoEditorColorThemes, Latexify, Measures, ProjectRoot, WAV
end

# ╔═╡ 2ca3355a-58d6-4323-a697-16e486524d9a
# ╠═╡ show_logs = false
include("../iii_utils.jl");

# ╔═╡ 7e060b26-118c-445b-be90-8034517ec277
md"""
# Non-periodic Oscillations

We can extend the elementary oscillations to non-integer indices:

$E_{\omega} = C(\omega)e^{-i\omega t}$

with $\omega \in \mathbb{R}$ and $C(\omega) \in \mathbb{C}$

Then, every element is periodic with a period $T=2\pi/\omega$ but a sum of elementary oscillations of this type is no longer periodic because in general the periods are non conmensurable

This leads to inharmonic sounds (without a stable intonation).
"""

# ╔═╡ c8bf120f-b2dc-4e90-90e7-12d2fdb1c660
begin
	ncycles = 5
	@bind t_1 Clock(0.1,true,false,200*ncycles+1,false)
end	

# ╔═╡ 560c2913-06c2-401b-a9bc-895159fdeacd
begin
	ncycles2 = 5
	@bind t_2 Clock(0.1,true,false,200*ncycles2+1,false)
end	

# ╔═╡ 19a48894-1887-4564-a814-4d2e833a18b2
md"""
# Decaying Oscillations

A further generalization is to make the exponent complex instead of purely imaginary.

As we have seen before these means that the amplitude of the oscillations can grow or decay exponentially in time, tracing spirals in the complex plane. We will consider decaying oscillations only given by $-\alpha$ with $\alpha>0$

$E_{\omega} = C(\omega)e^{-\alpha(\omega)t}e^{i\omega t}$
"""

# ╔═╡ 1bec2bdb-961a-4c41-ae04-7616d408dc56
md"""
## Bells

A simple resynthesis of the P.A.F. Bells can be made using just only five to seven generalized elementary oscillations with given frequency, amplitude and decay.

Here is a table of the main frequencies present in the bells. 

$$\begin{aligned}
\begin{array}{|c|c|}
\hline \hline  Big Bell (D)  & Small Bell (A)  \\
\begin{array}{|c|c|c|c|}
\hline\hline
\# & \text{freq. (Hz)} & \text{amplitude} & \text{decay (s)}\\
\hline
1 & 296 & 1.00 & 3.0 \\
2 & 595 & 0.50 & 2.1 \\
3 & 696 & 0.40 & 1.9 \\
4 & 899 & 0.01 & 0.7 \\
5 & 1149 & 0.25 & 0.9 \\
6 & 1533 & 0.02 & 0.5 \\
7 & 1611 & 0.03 & 0.5 \\
8 & 1716 & 0.20 & 0.7 \\
9 & 1968 & 0.02 & 0.6 \\
10 & 2362 & 0.02 & 0.7 \\
11 & 2465 & 0.02 & 0.6 \\
12 & 3069 & 0.07 & 0.7 \\
\hline
\end{array}
& \begin{array}{|c|c|c|c|}
\hline\hline
\# & \text{freq. (Hz)} & \text{amplitude} & \text{decay (s)}\\
\hline
1 & 441  & 1.00 & 2.0 \\
2 & 935  & 0.71 & 1.5 \\
3 & 1080 & 0.71 & 1.2 \\
4 & 1353 & 0.22 & 0.4 \\
5 & 1799 & 0.40 & 0.5 \\
6 & 2307 & 0.16 & 0.3 \\
7 & 2454 & 0.11 & 0.3 \\
8 & 2689 & 0.22 & 0.3 \\
9 & 3694 & 0.40 & 0.4 \\
\hline
\end{array}
\end{array}
\end{aligned}$$



"""

# ╔═╡ ec81f3ed-2840-430f-85d5-05eca5a779b6
md"""
We synthesize a "minimal" D Bell using the strongest 6 elementary oscillations (also called **partials**)
"""

# ╔═╡ c2914d60-04d6-4545-92f1-d5ddf7c649ae
begin
	ncycles3 = 10
	@bind t_3 Clock(0.1,true,false,200*ncycles3+1,false)
end	

# ╔═╡ db0af527-3f1b-43ee-a088-089207e313f6
begin
	t3 = (t_3-1)*(4*pi)/400
	AB1 = [1.0 0.7 0.4 0.25 0.2 0.07]
	fB1 = [296 595 696 1149 1716 3096]
	dB1 = [3.0 2.1 1.9 1.0 0.8 0.8]
	AmaxB1 = 2
	ωB1 = fB1/100
	pB1, pB2 = plot_ntones_decay(t3,AB1[1,:],ωB1[1,:],0.01./dB1[1,:],AB1[1,:]*0,AmaxB1;ncycles=ncycles3)
	plot(pB1,pB2, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],bottom_margin=[7mm 7mm],size=(1200,430))
end

# ╔═╡ 4c226e12-0d7c-4ccc-a5ce-36817ce4a768
md"""
$(@bind play CounterButton("Play"))
"""

# ╔═╡ ae1d669e-f57b-458c-9eb5-09ba61c39878
# ╠═╡ disabled = true
#=╠═╡
plot(ts,snd,size=(1200,300),xlabel="time (s)",bottom_margin=10mm,label="")
  ╠═╡ =#

# ╔═╡ 15b2aac7-f89b-4949-9a1c-3b440835312f
# ╠═╡ disabled = true
#=╠═╡
let 
	play 
	wavplay("bell.wav")
end
  ╠═╡ =#

# ╔═╡ 3f183134-2a68-4bb2-83de-53fa0903a349
begin
	fs = 44100
	dt = 1/fs
	dur = 8.0
	ts = collect(0:dt:dur)
	components = AB1.*sin.(2*pi*fB1.*ts).*exp.(-ts./dB1)
	snd = sum(components,dims=2)
end;

# ╔═╡ b536fcec-f092-4b96-9718-218ea446e748
# ╠═╡ disabled = true
#=╠═╡
wavwrite(Int.(trunc.(0.9*snd/maximum(abs.(snd))*2^15)), "bell.wav", Fs=fs, nbits=16)
  ╠═╡ =#

# ╔═╡ 4e156f4c-8425-41fd-9abb-64261ab3cda2
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
	width: 20%;
}
pluto-helpbox { display: none; } 
</style>
"""

# ╔═╡ e55ad533-c6ad-449c-b127-24ca36731585
sp = html"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";

# ╔═╡ 0e34247d-671a-46b3-be5b-3f4545d848f0
md"""
ω₁ = $(@bind ω1 Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A₁ = $(@bind A1 Slider(0:0.02:2,default=1.0;show_value=true)) $sp
ϕ₁ = $(@bind ϕ1 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω₂ = $(@bind ω2 Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A₂ = $(@bind A2 Slider(0:0.02:2,default=1.0;show_value=true)) $sp
ϕ₂ = $(@bind ϕ2 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω₃ = $(@bind ω3 Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A₃ = $(@bind A3 Slider(0:0.02:2,default=1.0;show_value=true)) $sp
ϕ₃ = $(@bind ϕ3 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
"""

# ╔═╡ 52f0eb33-18b6-452d-a250-65a54d96080f
begin
	t1 = (t_1-1)*(4*pi)/400
	Amps = [A1, A2, A3]
	ϕs = [ϕ1,ϕ2,ϕ3]
	ωs = [ω1,ω2,ω3]
	Amax = 6
	p1,p2 = plot_ntones(t1,Amps,ωs,ϕs,Amax;plot_trace=true, ncycles=ncycles)
	plot(p1,p2, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],bottom_margin=[7mm 7mm],size=(1200,430))
end	

# ╔═╡ 4542c858-9fc8-494b-9d5d-f1ad8c65791b
md"""
ω₁ = $(@bind ω1b Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A₁ = $(@bind A1b Slider(0:0.02:2,default=1.0;show_value=true)) \
α₁ = $(@bind d1b Slider(0:0.002:0.2,default=0.0;show_value=true)) $sp
ϕ₁ = $(@bind ϕ1b Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω₂ = $(@bind ω2b Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A₂ = $(@bind A2b Slider(0:0.02:2,default=1.0;show_value=true)) \
α₂ = $(@bind d2b Slider(0:0.002:0.2,default=0.0;show_value=true)) $sp
ϕ₂ = $(@bind ϕ2b Slider(0:0.02:6.28,default=0.0;show_value=true)) \
ω₃ = $(@bind ω3b Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A₃ = $(@bind A3b Slider(0:0.02:2,default=1.0;show_value=true)) \
α₃ = $(@bind d3b Slider(0:0.002:0.2,default=0.0;show_value=true)) $sp
ϕ₃ = $(@bind ϕ3b Slider(0:0.02:6.28,default=0.0;show_value=true)) \
"""

# ╔═╡ 9e4ea208-108c-49e2-a098-38e00a0d8fcb
begin
	t2 = (t_2-1)*(4*pi)/400
	Ampsb = [A1b, A2b, A3b]
	ϕsb = [ϕ1b,ϕ2b,ϕ3b]
	ωsb = [ω1b,ω2b,ω3b]
	ddb = [d1b,d2b,d3b]
	Amaxb = 6
	p1b,p2b = plot_ntones_decay(t2,Ampsb,ωsb,ddb,ϕsb,Amaxb; plot_trace=true, ncycles=ncycles2)
	plot(p1b,p2b, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],bottom_margin=[7mm 7mm],size=(1200,430))
end	

# ╔═╡ Cell order:
# ╟─7e060b26-118c-445b-be90-8034517ec277
# ╟─c8bf120f-b2dc-4e90-90e7-12d2fdb1c660
# ╟─0e34247d-671a-46b3-be5b-3f4545d848f0
# ╟─52f0eb33-18b6-452d-a250-65a54d96080f
# ╟─560c2913-06c2-401b-a9bc-895159fdeacd
# ╟─19a48894-1887-4564-a814-4d2e833a18b2
# ╟─4542c858-9fc8-494b-9d5d-f1ad8c65791b
# ╟─9e4ea208-108c-49e2-a098-38e00a0d8fcb
# ╟─1bec2bdb-961a-4c41-ae04-7616d408dc56
# ╟─ec81f3ed-2840-430f-85d5-05eca5a779b6
# ╟─c2914d60-04d6-4545-92f1-d5ddf7c649ae
# ╟─db0af527-3f1b-43ee-a088-089207e313f6
# ╟─4c226e12-0d7c-4ccc-a5ce-36817ce4a768
# ╠═ae1d669e-f57b-458c-9eb5-09ba61c39878
# ╟─15b2aac7-f89b-4949-9a1c-3b440835312f
# ╟─3f183134-2a68-4bb2-83de-53fa0903a349
# ╟─b536fcec-f092-4b96-9718-218ea446e748
# ╟─2ca3355a-58d6-4323-a697-16e486524d9a
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─4e156f4c-8425-41fd-9abb-64261ab3cda2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─e55ad533-c6ad-449c-b127-24ca36731585
