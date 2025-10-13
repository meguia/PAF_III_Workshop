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
# Fourier Series
## Orthogonality from circle symmetry

We will define the k-th elementary rotation

$E_k(t) = e^{ikt}$

with $k \in \mathbb{Z}$. For simplicity we are keeping the fundamental period $T=2\pi$, but a more general k-th elementary rotation for an arbitrary period $T$ can be defined by setting $\omega_0 = 2\pi/T$ and then $E_k(t) = e^{ik\omega_0 t}$.

Product of two elements add indices:

$E_k(t)E_l(t) = e^{ikt}e^{ilt} = = e^{i(k+l)t} = E_{k+l}(t)$

A time shift of $\tau$ mutiply the element for a phase:

$E_k(t-\tau) = e^{-ik\tau}E_k(t)$

The complex conjugate of the element is an element with the opposite sign:

$\overline{E_k(t)} = e^{-ikt} = E_{-k}(t)$

We define the scalar product of two elements as the average over a full period after conjugating the second element

$E_k \cdot E_k = \langle E_k(t) \overline{E_k(t)}\rangle_T = \langle e^{ikt}e^{-ikt} \rangle_T = \langle 1 \rangle_T = 1$ 

"""

# ╔═╡ 263affc0-a928-4d6f-97e9-48aa6126d1f3
@bind t_1 Clock(0.1,true,false,401,false)

# ╔═╡ a2f57914-6a31-4e3b-ab6d-2dadfc76938d
begin
	t1 = mod(t_1-0.99,400)*(4*pi)/400
	nmod = 6
	pps = plot_fasors(t1,ones(2*nmod,),vcat([1:nmod,-1:-1:-nmod]...),zeros(2*nmod,),1.05)
	plot(pps...,layout=(2,nmod),size=(1200,400),left_margin=[-10mm -10mm])
end	

# ╔═╡ 8338e09a-6751-4aaf-b5a1-8c651e6c5cb8
md"""
The average of the elementary rotation over a full period is zero except for $k=0$

$\langle E_k(t) \rangle_T = 0 \quad for \quad k\neq 0$

The scalar product of two elementary rotations:

$E_k \cdot E_l = \langle E_k(t)\overline{E_l(t)} \rangle_T = \langle E_{k-l}(t) \rangle_T = 0 \quad if \quad k\neq l$

Therefore, all elementary rotations are orthogonal. Only equal indices survive.
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
main {
    max-width: 1000px;
}
input[type*="range"] {
	width: 25%;
}
</style>
"""

# ╔═╡ 234a88c7-314b-419e-9092-7d00be674b2b
sp = html"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";

# ╔═╡ Cell order:
# ╟─83f8450d-3225-4f37-ba5d-9f510cf0d497
# ╟─263affc0-a928-4d6f-97e9-48aa6126d1f3
# ╟─a2f57914-6a31-4e3b-ab6d-2dadfc76938d
# ╟─8338e09a-6751-4aaf-b5a1-8c651e6c5cb8
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─b708f59c-905d-45d8-8a48-70b3bb534af5
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─234a88c7-314b-419e-9092-7d00be674b2b
