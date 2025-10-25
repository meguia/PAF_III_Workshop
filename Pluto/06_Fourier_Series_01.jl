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
# Fourier Series (part I)

## Elementary Oscillations 

We will define the k-th elementary oscillation

$E_k(t) = e^{ikt}$

with $k \in \mathbb{Z}$. For simplicity we are keeping the fundamental period $T=2\pi$, but a more general k-th elementary oscillation for an arbitrary period $T$ can be defined by setting $\omega_0 = 2\pi/T$ and then $E_k(t) = e^{ik\omega_0 t}$.

## Properties 

Product of two elements add indices:

$E_k(t)E_j(t) = e^{ikt}e^{ijt} = = e^{i(k+j)t} = E_{k+j}(t)$

The complex conjugate of the element is an element with the opposite sign:

$\overline{E_k(t)} = e^{-ikt} = E_{-k}(t)$

Derivation equals multiplying by $ik$

$\frac{d}{dt} e^{ikt} = ike^{ikt}$

The antiderivative corresponds to multiplying by $-i/k$

$\int_{t_1}^{t_2} e^{ikt} dt = -\frac{i}{k}(e^{ikt_2} - e^{ikt_1})$ 
"""

# ╔═╡ 74ac1574-8b21-499c-891d-70c6e510cfa0
md"""
## Elementary Oscillations from k=-6 to k=6
"""

# ╔═╡ 263affc0-a928-4d6f-97e9-48aa6126d1f3
@bind t_1 Clock(0.2,true,false,401,false)

# ╔═╡ a2f57914-6a31-4e3b-ab6d-2dadfc76938d
begin
	t1 = mod(t_1-0.99,400)*(4*pi)/400
	nmod = 6
	pps = plot_fasors(t1,ones(2*nmod+1,),vcat([nmod:-1:0, -nmod:1:-1]...),zeros(2*nmod+1,),1.05)
	plot(pps...,layout=(2,nmod+1),size=(1200,400),left_margin=[-10mm -10mm])
end	

# ╔═╡ 8338e09a-6751-4aaf-b5a1-8c651e6c5cb8
md"""
## Averages 

The average of the elementary oscillation over a full period ($T=2\pi$ in our simplified case) is zero except for $k=0$

$\langle E_k(t) \rangle_{2\pi} = 0 \quad for \quad k\neq 0$

We can compute this average over a full period using the integral of the time differential from $0$ to $2\pi$. 

for $k\neq 0$: 

$\langle E_k(t) \rangle_{2\pi} =\frac{1}{2\pi}\int_0^{2\pi} e^{ikt} dt =  -\frac{i}{k2\pi} (e^{ik2\pi} - e^{ik0}) = -\frac{i}{k2\pi}(1 - 1) = 0$

and for $k=0$:

$\langle E_0(t) \rangle_{2\pi} = \frac{1}{2\pi}\int_0^{2\pi} dt = \frac{1}{2\pi}(2\pi-0)= 1$
"""



# ╔═╡ ecb1db55-62ed-4afa-bc29-ee1950e50f46
md"""
## Product with the conjugate to "freeze"

Suppose that we have one element $E_k(t)$ and we don't know the index $k$. 

One way to discover $k$ is to multiply $E_k(t)$ by the conjugate of an element with an index $j$ that we know:


$E_k(t)\overline{E_j(t)}=E_k(t)E_{-j}(t)=E_{k-j}(t)$ 

and "observe its behavior". If it rotates then $k \neq j$. If it "freezes" then we matched the index $k=j$. 


"""

# ╔═╡ 2924bbc2-e3d5-4a80-a8e0-f44f7e7fb6aa
@bind t_2 Clock(0.1,true,false,401,false)

# ╔═╡ d2ac89ac-a0b8-49aa-8830-521b5bcba681
md"""
# Averaged product between elements

Taking this into account it would be useful to define the "product" between two elements, as the product of the first and the conjugate of the second averaged over one period:

$\langle E_k,E_j \rangle \doteq \langle E_k(t)\overline{E_j(t)} \rangle_T = \langle E_{k-j}(t) \rangle_T$

This product will be:

$\langle E_k,E_j \rangle = 0 \quad for \quad k\neq j$

$\langle E_k,E_j \rangle = 1 \quad for \quad k = j$

Therefore, all elementary oscillations are orthogonal. Only equal indices survive.

"""

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
	width: 25%;
}
pluto-helpbox {
    display: none;
}
</style>
"""

# ╔═╡ 234a88c7-314b-419e-9092-7d00be674b2b
sp = html"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";

# ╔═╡ fd653582-1eef-4069-a102-315badc98a70
md"""
k $(@bind k Slider(-6:1:6,default=1;show_value=true)) $sp
j $(@bind j Slider(-6:1:6,default=3;show_value=true))
"""

# ╔═╡ 4f029a92-bcb9-4b11-908c-68688f9d4a6a
begin
	t2 = mod(t_2-0.99,400)*(4*pi)/400
	p1,p2,p3 = plot_fasor_product(t2,1,1,k,j,0,0,1.5)
	plot(p1,p2,p3,layout=(1,3),size=(600,220),left_margin=[-10mm -10mm])
end	

# ╔═╡ Cell order:
# ╟─83f8450d-3225-4f37-ba5d-9f510cf0d497
# ╟─74ac1574-8b21-499c-891d-70c6e510cfa0
# ╟─263affc0-a928-4d6f-97e9-48aa6126d1f3
# ╟─a2f57914-6a31-4e3b-ab6d-2dadfc76938d
# ╟─8338e09a-6751-4aaf-b5a1-8c651e6c5cb8
# ╟─ecb1db55-62ed-4afa-bc29-ee1950e50f46
# ╟─2924bbc2-e3d5-4a80-a8e0-f44f7e7fb6aa
# ╟─4f029a92-bcb9-4b11-908c-68688f9d4a6a
# ╟─fd653582-1eef-4069-a102-315badc98a70
# ╟─d2ac89ac-a0b8-49aa-8830-521b5bcba681
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─b708f59c-905d-45d8-8a48-70b3bb534af5
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─234a88c7-314b-419e-9092-7d00be674b2b
