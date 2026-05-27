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
# Series de Fourier, parte II
"""

# ╔═╡ 706bd63b-25d8-4fe8-94cf-217e0f60cc09
md"""
## Medir cuanto hay de cada oscilacion

El producto promediado sirve para extraer cuanta cantidad de una frecuencia $E_k(t)=e^{ikt}$ hay dentro de una funcion periodica $s(t)$.

Multiplicamos por el conjugado:

$s(t)\overline{E_k(t)}$.

La componente k-esima deja de girar; las otras siguen girando. Al promediar durante un periodo, las que siguen girando se cancelan. El promedio define el coeficiente complejo:

$C_k=\langle s(t)\overline{E_k(t)}\rangle_T$.

Como $C_k$ es complejo, contiene amplitud y fase: $C_k=A_ke^{i\phi_k}$.
"""

# ╔═╡ 836adee0-bd41-4391-9831-09c18e4081e3
md"""
## Serie de Fourier

Una funcion periodica razonablemente regular, con periodo $2\pi$, puede escribirse como

$s(t)=\sum_{k=-\infty}^{\infty}C_ke^{ikt}$,

donde

$C_k=\frac{1}{2\pi}\int_0^{2\pi}s(t)e^{-ikt}\,dt$.

La integral es la operacion de medicion: pregunta cuanto de la frecuencia $k$ esta presente en la senal.
"""

# ╔═╡ e60b57f9-d4d0-47f1-8705-5f6858b7211f

md"""
## Ejemplo: senal cuadrada

Tomamos una senal cuadrada de periodo $2\pi$:

$s(t)=1$ si $t<\pi$ y $s(t)=-1$ si $t>\pi$.

Los coeficientes se calculan promediando por partes: una integral en la primera mitad del periodo y otra en la segunda. Visualmente, esto equivale a ver que contribuciones se cancelan y cuales quedan.
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
En este caso, al promediar sobre medio periodo, todos los terminos pares desaparecen.
"""

# ╔═╡ 851958fd-bcbd-4c6a-ac63-f6a5f190662c
md"""
$\int_0^{\pi} e^{-ikt} dt = \frac{i}{k}(e^{-ik\pi}-1)$.

Para $k$ par, $e^{-ik\pi}=1$ y la contribucion es cero. Para $k$ impar, $e^{-ik\pi}=-1$ y queda una contribucion distinta de cero.

Finalmente:

$C_k=\begin{cases}-i\frac{2}{k\pi}, & k\ \text{impar}\\0, & k\ \text{par}\end{cases}$

La senal cuadrada se reconstruye sumando solo armonicos impares. Al aumentar $N$, la aproximacion mejora, aunque cerca del salto aparece el fenomeno de Gibbs.
"""

# ╔═╡ 1ebb82c2-7d93-4784-a54d-eaf0f5e365f7
@bind t_2 Clock(0.1,true,false,401,true)

# ╔═╡ 52b6dde8-227d-41c8-99d5-99b23b7fed21
md"""
N $(@bind nmax Slider(1:2:21,default=1;show_value=true))

Usa solo valores impares para agregar armonicos impares a la reconstruccion.
"""

# ╔═╡ 8c3a84be-5b4d-4dec-b75d-f388307a9148
begin 
	t2 = mod(t_2-0.99,400)*(4*pi)/400
	frq = -nmax:2:nmax
	Amps = 2 ./(pi*frq)
	ϕs = -pi/2*ones(size(Amps))
	Am = 2.0
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
$(@bind play CounterButton("Reproducir"))

El sonido resultante se acerca a una onda cuadrada al agregar mas armonicos.
"""

# ╔═╡ ae2cf833-8618-4622-9218-6b3c6498f469
begin
	fs = 44100
	dt = 1/fs
	ts = collect(0:dt:2)
	N2 = Int((nmax+1)/2)
	AM = reshape(Amps[N2+1:end],1,N2)
	ωM = reshape(frq[N2+1:end],1,N2)*2*pi*f0
	components = AM.*sin.(ωM.*ts)
	snd = sum(components,dims=2)	
end;

# ╔═╡ 5d27b8a6-6e2c-4264-8406-06f7b5514a31
plot(snd[1:1000],label="",size=(1200,300))

# ╔═╡ 81a93524-596a-4053-b1bf-88ad64ae9022
wavwrite(Int.(trunc.(0.9*snd/maximum(abs.(snd))*2^15)), "square.wav", Fs=fs, nbits=16)

# ╔═╡ 6f966a00-7a71-4c4e-92ce-e95ec0f7c264
let 
	play 
	wavplay("square.wav")
end

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
# ╟─5d27b8a6-6e2c-4264-8406-06f7b5514a31
# ╟─ae2cf833-8618-4622-9218-6b3c6498f469
# ╟─81a93524-596a-4053-b1bf-88ad64ae9022
# ╟─6f966a00-7a71-4c4e-92ce-e95ec0f7c264
# ╟─45d2b2d7-3e53-44c0-a7b9-56c1794ebc2e
# ╟─b708f59c-905d-45d8-8a48-70b3bb534af5
# ╟─f701ab61-2512-4f2a-a182-a6f2b23e0bd2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─234a88c7-314b-419e-9092-7d00be674b2b
