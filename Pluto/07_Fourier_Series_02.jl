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
# Fourier Series (part II)

"""

# ╔═╡ 706bd63b-25d8-4fe8-94cf-217e0f60cc09
md"""
## Measuring “how much” of each oscillation

The averaged product can be also used to extract "how much" of each oscillation (with the frequency of $E_k(t)=e^{ikt}$) is present in any periodic function.

Let $s(t)$ be any $T$-periodic function. We are assuming that $s(t)$ can be composed by many (possibly infinite) different components (elementary oscillation)

To measure the k-th ingredient, first freeze it by multiplying with the complex conjugate of $E_k(t)$. 

$s(t)\overline{E_k(t)}$

The k-th component of $s(t)$ stops spinning and becomes steady. 
All other components keep spinning. 

Then we take the average over a period and use that average to define a complex coefficient $C_k$:


$C_k \doteq  \langle s(t)\overline{E_k(t)} \rangle_T$

This coefficient measures "how much" of $E_k$ is present, not only in amplitude but also with which phase because $C_k$ is complex so it has a angle:

$C_k = A_k e^{i\phi_k}$

where $A_k$ is the amplitude of the k-th component and $\phi_k$ its initial phase.
"""

# ╔═╡ 836adee0-bd41-4391-9831-09c18e4081e3
md"""
## Fourier Series

Any (reasonably continuous) $T=2\pi$-periodic function $s(t+2\pi)=s(t)$ may be expressed as a series (infinte sum) of $k-th$ components $E_k(t)$ with complex coefficients $C_k$

$s(t) = \sum_{k=-\infty}^{\infty} C_k E_k(t) = \sum_{k=-\infty}^{\infty} C_k e^{ikt}$ 

where:

$C_k = \langle s(t)\overline{E_k(t)} \rangle_{2\pi} = \frac{1}{2\pi}\int_0^{2\pi} s(t)e^{-ikt} dt$

"""

# ╔═╡ e60b57f9-d4d0-47f1-8705-5f6858b7211f

md"""

## Example

We can try with a square signal of period $2\pi$

$s(t) = \begin{cases} 1 & \text{if }  t<\pi\\ -1 & \text{if } t>\pi  \end{cases}$ 


$C_k = \frac{1}{2\pi}\int_0^{2\pi} s(t)e^{-ikt} dt = \frac{1}{\pi}\int_0^{\pi} 1e^{-ikt} dt + \frac{1}{\pi}\int_{\pi}^{2\pi} (-1)e^{-ikt} dt$

so now we are averaging over half a period. How is this average? First visually:
"""

# ╔═╡ 2924bbc2-e3d5-4a80-a8e0-f44f7e7fb6aa
@bind t_1 Clock(0.1,true,false,101,false)

# ╔═╡ 0da9d7b9-d063-4ccd-bb98-a1fceb014f92
begin
	t1 = mod(t_1-0.99,400)*(4*pi)/400
	nmod = 4
	pps = plot_fasors(t1,ones(2*nmod+1,),vcat([nmod:-1:0, -nmod:1:-1]...),zeros(2*nmod+1,),1.05)
	plot(pps...,layout=(2,nmod+1),size=(1200,500),left_margin=[-10mm -10mm])
end	

# ╔═╡ 3aea4336-0be8-4d67-8102-90574813afec
md"""
In this case when we take the average over half a period all even terms dissapear!
"""

# ╔═╡ 851958fd-bcbd-4c6a-ac63-f6a5f190662c
md"""
$\int_0^{\pi} e^{-ikt} dt =  \frac{1}{ik}(e^{-ik\pi}-e^{-ik0}) = -\frac{i}{k}(-1-1) = \begin{cases} i\frac{2}{k} \quad \text{if k odd}\\ 0 \quad \text{if k even} \end{cases}$

similarly:

$\int_{\pi}^{2\pi} e^{-ikt} dt =  \frac{1}{ik}(e^{-ik2\pi}-e^{-ik\pi}) = -\frac{i}{k}(1+1) = \begin{cases} -i\frac{2}{k} \quad \text{if k odd}\\ 0 \quad \text{if k even} \end{cases}$

Then finally:

$C_k = \frac{1}{\pi}\int_0^{\pi} e^{-ikt} dt - \frac{1}{\pi}\int_{\pi}^{2\pi} e^{-ikt} dt = \begin{cases} i\frac{4}{k\pi} \quad \text{if k odd}\\ 0 \quad \text{if k even} \end{cases}$

and the series is:

$s(t) =$
"""

# ╔═╡ 1ebb82c2-7d93-4784-a54d-eaf0f5e365f7
@bind t_2 Clock(0.1,true,false,401,false)

# ╔═╡ 52b6dde8-227d-41c8-99d5-99b23b7fed21
md"""
N $(@bind nmax Slider(1:2:21,default=1;show_value=true))
"""

# ╔═╡ 8c3a84be-5b4d-4dec-b75d-f388307a9148
begin 
	t2 = mod(t_2-0.99,400)*(4*pi)/400
	frq = -nmax:2:nmax
	Amps = 4 ./(pi*frq)
	ϕs = -pi/2*ones(size(Amps))
	Am = 4.0
	l2 = @layout [[a{0.33w, 0.33h} b{0.66w}]; c{0.33w, 0.66h} _{0.66w}]
	plts = plot_ntones_twoaxis(t2,Amps,frq,ϕs,Am;plot_trace=true)
	plot(plts...,layout=l2, left_margin=[10mm -13mm],top_margin=[-10mm 13mm],size=(1200,1200))
end	

# ╔═╡ b708f59c-905d-45d8-8a48-70b3bb534af5
begin
	stylefile = joinpath(@projectroot,"Pluto","light_33.css")
	PlutoEditorColorThemes.setcolortheme!(stylefile)
end

# ╔═╡ 18267cb1-99b8-4ed4-8558-1de0bdae4795
html"""
<style>
pluto-notebook {
    max-width: 1000px !important;
}
input[type*="range"] {
	width: 70%;
}
pluto-helpbox {
    display: none;
}
</style>
"""

# ╔═╡ 234a88c7-314b-419e-9092-7d00be674b2b
sp = html"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";

# ╔═╡ 62758eff-a3c9-4858-8b96-69205658b154
md"""
f0 $(@bind f0 Slider(100:10:200,default=100;show_value=true)) $sp
$(@bind play CounterButton("Play"))
"""

# ╔═╡ ae2cf833-8618-4622-9218-6b3c6498f469
# ╠═╡ disabled = true
#=╠═╡
begin
	fs = 44100
	dt = 1/fs
	ts = collect(0:dt:2)
	N2 = Int((nmax+1)/2)
	AM = reshape(Amps[N2+1:end],1,N2)
	ωM = reshape(frq[N2+1:end],1,N2)*2*pi*f0
	components = AM.*sin.(ωM.*ts)
	snd = sum(components,dims=2)
	wavwrite(Int.(trunc.(0.9*snd/maximum(abs.(snd))*2^15)), "square.wav", Fs=fs, nbits=16)
end	
  ╠═╡ =#

# ╔═╡ 5d27b8a6-6e2c-4264-8406-06f7b5514a31
# ╠═╡ disabled = true
#=╠═╡
plot(snd[1:1000],label="",size=(1200,300))
  ╠═╡ =#

# ╔═╡ 6f966a00-7a71-4c4e-92ce-e95ec0f7c264
# ╠═╡ disabled = true
#=╠═╡
let 
	play 
	wavplay("square.wav")
end
  ╠═╡ =#

# ╔═╡ Cell order:
# ╟─83f8450d-3225-4f37-ba5d-9f510cf0d497
# ╟─706bd63b-25d8-4fe8-94cf-217e0f60cc09
# ╟─836adee0-bd41-4391-9831-09c18e4081e3
# ╟─e60b57f9-d4d0-47f1-8705-5f6858b7211f
# ╟─2924bbc2-e3d5-4a80-a8e0-f44f7e7fb6aa
# ╟─0da9d7b9-d063-4ccd-bb98-a1fceb014f92
# ╟─3aea4336-0be8-4d67-8102-90574813afec
# ╟─851958fd-bcbd-4c6a-ac63-f6a5f190662c
# ╟─1ebb82c2-7d93-4784-a54d-eaf0f5e365f7
# ╟─52b6dde8-227d-41c8-99d5-99b23b7fed21
# ╟─8c3a84be-5b4d-4dec-b75d-f388307a9148
# ╟─62758eff-a3c9-4858-8b96-69205658b154
# ╠═ae2cf833-8618-4622-9218-6b3c6498f469
# ╠═5d27b8a6-6e2c-4264-8406-06f7b5514a31
# ╠═6f966a00-7a71-4c4e-92ce-e95ec0f7c264
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─b708f59c-905d-45d8-8a48-70b3bb534af5
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─234a88c7-314b-419e-9092-7d00be674b2b
