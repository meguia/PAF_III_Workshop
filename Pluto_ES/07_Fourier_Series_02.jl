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

Ahora una senal periodica es un array de $N$ samples:

$s = [s[0], s[1], \ldots, s[N-1]]$.

Para medir cuanto del bin $k$ hay en la senal, multiplicamos sample por sample por el conjugado de ese bin y promediamos:

$C_k = \frac{1}{N}\sum_{n=0}^{N-1}s[n]\overline{E_k[n]}$.

Como $E_k[n]=e^{i2\pi kn/N}$, tambien podemos escribir:

$C_k = \frac{1}{N}\sum_{n=0}^{N-1}s[n]e^{-i2\pi kn/N}$.

Este numero $C_k$ es complejo. Su modulo indica la amplitud del bin y su angulo indica la fase. En otras palabras: el coeficiente no solo dice "cuanto hay", tambien dice "con que alineacion de fase aparece".
"""

# ╔═╡ 836adee0-bd41-4391-9831-09c18e4081e3
md"""
## Transformada discreta de Fourier

La DFT toma un array de samples y devuelve otro array: el array de coeficientes de frecuencia.

Analisis:

$C_k = \frac{1}{N}\sum_{n=0}^{N-1}s[n]e^{-i2\pi kn/N}$.

Sintesis:

$s[n] = \sum_{k=0}^{N-1}C_k e^{i2\pi kn/N}$.

La primera suma mide la senal contra cada bin. La segunda suma reconstruye la senal sumando todos los bins medidos. No estamos pasando por funciones continuas: todo ocurre dentro de arrays finitos.
"""

# ╔═╡ e60b57f9-d4d0-47f1-8705-5f6858b7211f
md"""
## Ejemplo: senal cuadrada sampleada

Tomamos un array que representa un periodo de una senal cuadrada:

$s[n]=1$ para la primera mitad de los samples, y $s[n]=-1$ para la segunda mitad.

Los coeficientes se calculan con la suma discreta de la DFT. Visualmente, cada bin gira a una velocidad distinta. Cuando multiplicamos la senal por el conjugado del bin correcto, esa componente queda alineada y sobrevive al promedio. Las componentes que no coinciden se cancelan al sumar.
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
En la senal cuadrada, los bins pares tienden a cancelarse por simetria: la primera mitad positiva y la segunda mitad negativa empujan en direcciones opuestas. Por eso la energia principal aparece en bins impares.
"""

# ╔═╡ 851958fd-bcbd-4c6a-ac63-f6a5f190662c
md"""
La lectura discreta es:

$C_k = \frac{1}{N}\sum_{n=0}^{N-1}s[n]e^{-i2\pi kn/N}$.

Si $s[n]$ es cuadrada y simetrica, muchos bins se cancelan exactamente o casi exactamente. Los bins impares son los que mas contribuyen a reconstruir los saltos.

Cuando reconstruimos usando solo algunos bins:

$\hat{s}[n] = \sum_{k\in K}C_k e^{i2\pi kn/N}$,

obtenemos una aproximacion. Al agregar mas bins, la forma se parece mas a la cuadrada. Cerca de los saltos aparece una oscilacion caracteristica: el fenomeno de Gibbs.
"""

# ╔═╡ 1ebb82c2-7d93-4784-a54d-eaf0f5e365f7
@bind t_2 Clock(0.1,true,false,401,true)

# ╔═╡ 52b6dde8-227d-41c8-99d5-99b23b7fed21
md"""
N $(@bind nmax Slider(1:2:21,default=1;show_value=true))

Este control elige cuantos bins impares conservar alrededor de la frecuencia cero. La reconstruccion usa coeficientes calculados desde samples discretos.
"""

# ╔═╡ 8c3a84be-5b4d-4dec-b75d-f388307a9148
begin 
	t2 = mod(t_2-0.99,400)*(4*pi)/400
	frq = collect(-nmax:2:nmax)
	Ncoef = 512
	ncoef = collect(0:Ncoef-1)
	s_array = ifelse.(ncoef .< Ncoef/2, 1.0, -1.0)
	Csel = [sum(s_array .* exp.(-im*2*pi*k .* ncoef ./ Ncoef))/Ncoef for k in frq]
	Amps = abs.(Csel)
	ϕs = angle.(Csel)
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

El sonido usa la misma idea: sumar bins discretos medidos de la senal cuadrada sampleada.
"""

# ╔═╡ ae2cf833-8618-4622-9218-6b3c6498f469
begin
	fs = 44100
	dt = 1/fs
	ts = collect(0:dt:2)
	pos = frq .> 0
	Cpos = Csel[pos]
	frqpos = frq[pos]
	components = 2 .* abs.(Cpos)' .* cos.(2*pi*f0 .* ts .* frqpos' .+ angle.(Cpos)')
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
