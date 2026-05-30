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

## De funciones continuas a arrays de samples

En esta version vamos a pensar todas las senales como arrays finitos:

$s = [s[0], s[1], \ldots, s[N-1]]$.

Cada entrada $s[n]$ es un sample. Suponemos que esos $N$ samples cubren un periodo completo de la señal. Entonces todo el trabajo matematico se hace con sumas finitas: promedios, mediciones y productos escalares.

Vamos a calcular primero cuales serian las frecuencias que oscilan un numero **entero** de veces en esos N samples (porque queremos que la señal sea periodica).
La frecuencia mas baja es la que hace un ciclo completo de $2\pi$ en los N samples, es decir cuando  $n=N$ tenemos la fase igual a $2\pi$ y para cualquier otro sample la fase va a valer 

$\theta[n] = 2\pi n /N$

y la oscilacion elemental correspondiente a esa frecuencia mas baja (o fundamental, que vamos a llamar frecuencia 1) es

$E_1[n] = e^{i\theta} = e^{i 2\pi n/N}$

Las otras frecuencias me van a dar lo que se conoce como 
bloque elemental (o base) de Fourier discreto y son los multiplos enteros (positivos y negativos) de esta frecuencia fundamental y estan dados por el array:

$E_k[n] = e^{i 2\pi k n/N}$, con $n=0,\ldots,N-1$.

El indice $k$ indica cuantas vueltas completa esa oscilacion dentro de los $N$ samples. En la DFT, los valores de $k$ son bins de frecuencia. Como el array es finito, los indices se leen modulo $N$: por ejemplo, $k=N-1$ representa la frecuencia $-1$.

La idea conceptual es esta: medimos una senal comparandola con estos arrays giratorios.
"""

# ╔═╡ 74ac1574-8b21-499c-891d-70c6e510cfa0
md"""
## Oscilaciones elementales de k=-6 a k=6

La animacion muestra la geometria de varios bins. Las frecuencias positivas giran en un sentido, las negativas en el contrario, y $k=0$ no gira: es el array constante.

Aunque el dibujo usa un parametro continuo para mostrar la rotacion, la interpretacion que usaremos desde ahora es discreta: miramos solamente los valores en los samples $n=0,\ldots,N-1$.
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
## Promedios discretos

El promedio de un array de $N$ samples es

$\mathrm{promedio}(x)=\frac{1}{N}\sum_{n=0}^{N-1} x[n]$.

Para una oscilacion elemental:

$\frac{1}{N}\sum_{n=0}^{N-1}E_k[n]=0$ si $k\neq0$ modulo $N$.

Para $k=0$, $E_0[n]=1$ en todos los samples, entonces el promedio vale $1$.

Geometricamente: cuando $k\neq0$, los puntos se reparten alrededor del circulo complejo y se cancelan al sumar. Cuando $k=0$, todos los puntos estan en $1$ y no hay cancelacion.
"""



# ╔═╡ ecb1db55-62ed-4afa-bc29-ee1950e50f46
md"""
## Multiplicar por el conjugado para "congelar"

Si tenemos un bin $E_k$ y queremos saber si coincide con otro bin $E_j$, multiplicamos sample por sample por el conjugado:

$(E_k \cdot \overline{E_j})[n] = E_k[n]\overline{E_j[n]} = E_{k-j}[n]$.

Si $k=j$, el resultado es $E_0[n]=1$: queda congelado. Su promedio es $1$.

Si $k\neq j$, el resultado sigue girando. Al promediar sobre todos los samples, se cancela y da $0$.
"""

# ╔═╡ 2924bbc2-e3d5-4a80-a8e0-f44f7e7fb6aa
@bind t_2 Clock(0.1,true,false,401,true)

# ╔═╡ d2ac89ac-a0b8-49aa-8830-521b5bcba681
md"""
# Producto escalar discreto entre bins

Definimos el producto escalar entre dos arrays complejos como:

$\langle x,y\rangle = \frac{1}{N}\sum_{n=0}^{N-1}x[n]\overline{y[n]}$.

Para los bins de Fourier:

$\langle E_k,E_j\rangle = \frac{1}{N}\sum_{n=0}^{N-1}E_k[n]\overline{E_j[n]}$.

El resultado es $1$ si $k=j$ modulo $N$, y $0$ si no coinciden. Esta es la ortogonalidad discreta: cada bin mide una direccion independiente dentro del espacio de arrays de longitud $N$.
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

Probar valores iguales y distintos. Si coinciden, el producto deja de girar; si no coinciden, el promedio discreto se cancela.
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
