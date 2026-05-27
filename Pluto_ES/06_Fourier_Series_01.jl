### A Pluto.jl notebook ###
# v0.20.27

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
# Series de Fourier, parte I

## Oscilaciones elementales

Definimos la k-esima oscilacion elemental:

$E_k(t)=e^{ikt}$, con $k\in\mathbb{Z}$.

Tomamos periodo fundamental $T=2\pi$. Para otro periodo $T$, se usa $\omega_0=2\pi/T$ y $E_k(t)=e^{ik\omega_0t}$.

Propiedades importantes:

$E_k(t)E_j(t)=E_{k+j}(t)$

$\overline{E_k(t)}=E_{-k}(t)$

$\frac{d}{dt}e^{ikt}=ike^{ikt}$

Estas reglas hacen que las oscilaciones elementales funcionen como una base algebraica para senales periodicas.
"""

# ╔═╡ 74ac1574-8b21-499c-891d-70c6e510cfa0
md"""
## Oscilaciones elementales de k=-6 a k=6

Las frecuencias negativas giran en sentido contrario. La frecuencia $k=0$ no gira: es una constante.
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
## Promedios

El promedio de una oscilacion elemental en un periodo completo es cero, excepto para $k=0$:

$\langle E_k(t)\rangle_{2\pi}=0$ si $k\neq0$, y $\langle E_0(t)\rangle_{2\pi}=1$.

La razon geometrica es que una vuelta completa alrededor del circulo se cancela: las contribuciones en direcciones opuestas suman cero.
"""



# ╔═╡ ecb1db55-62ed-4afa-bc29-ee1950e50f46
md"""
## Multiplicar por el conjugado para "congelar"

Si tenemos $E_k(t)$ y queremos detectar su indice, lo multiplicamos por el conjugado de una oscilacion conocida $E_j(t)$:

$E_k(t)\overline{E_j(t)}=E_{k-j}(t)$.

Si $k=j$, queda $E_0(t)=1$, que no gira. Si $k\neq j$, sigue girando y su promedio es cero.
"""

# ╔═╡ 2924bbc2-e3d5-4a80-a8e0-f44f7e7fb6aa
@bind t_2 Clock(0.1,true,false,401,true)

# ╔═╡ d2ac89ac-a0b8-49aa-8830-521b5bcba681
md"""
# Producto promediado entre elementos

Definimos un producto interno como el promedio de una oscilacion por el conjugado de otra:

$\langle E_k,E_j\rangle=\langle E_k(t)\overline{E_j(t)}\rangle_T$.

El resultado es $0$ si $k\neq j$ y $1$ si $k=j$. Esto significa que las oscilaciones elementales son ortogonales: solo coinciden consigo mismas.
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

Prueba valores iguales y distintos para ver cuando el producto queda quieto.
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
