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
# Oscilaciones no periodicas

Podemos extender las oscilaciones elementales a indices no enteros:

$E_{\omega}(t)=C(\omega)e^{-i\omega t}$,

con $\omega\in\mathbb{R}$ y $C(\omega)\in\mathbb{C}$. Cada componente individual es periodica, pero una suma de frecuencias que no son multiplos enteros de una misma base puede no repetir nunca exactamente. Esto produce sonidos inarmonicos, con una altura menos estable.
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
# Oscilaciones con decaimiento

Otra generalizacion es usar exponentes complejos con parte real negativa:

$E_{\omega}(t)=C(\omega)e^{-\alpha(\omega)t}e^{i\omega t}$, con $\alpha>0$.

La parte $e^{-\alpha t}$ reduce la amplitud con el tiempo. En el plano complejo, la trayectoria deja de ser un circulo y se convierte en una espiral hacia el origen.
"""

# ╔═╡ 1bec2bdb-961a-4c41-ae04-7616d408dc56
md"""
## Campanas

Una campana puede resintetizarse con pocas oscilaciones generalizadas: frecuencia, amplitud y decaimiento. Las frecuencias no son armonicos exactos, por eso el sonido de campana es inarmonico.

La tabla muestra parciales principales para dos campanas P.A.F. Cada fila indica una componente: su frecuencia en Hz, su amplitud relativa y su tiempo de decaimiento.
"""

# ╔═╡ ec81f3ed-2840-430f-85d5-05eca5a779b6
md"""
Sintetizamos una campana D minima usando las seis oscilaciones elementales mas fuertes, tambien llamadas **parciales**.
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
$(@bind play CounterButton("Reproducir"))

El boton reproduce la resintesis cuando el audio esta habilitado.
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
omega1 = $(@bind ω1 Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A1 = $(@bind A1 Slider(0:0.02:2,default=1.0;show_value=true)) $sp
phi1 = $(@bind ϕ1 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
omega2 = $(@bind ω2 Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A2 = $(@bind A2 Slider(0:0.02:2,default=1.0;show_value=true)) $sp
phi2 = $(@bind ϕ2 Slider(0:0.02:6.28,default=0.0;show_value=true)) \
omega3 = $(@bind ω3 Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A3 = $(@bind A3 Slider(0:0.02:2,default=1.0;show_value=true)) $sp
phi3 = $(@bind ϕ3 Slider(0:0.02:6.28,default=0.0;show_value=true)) \

Usa frecuencias no enteras para ver que la forma deja de repetirse limpiamente.
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
omega1 = $(@bind ω1b Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A1 = $(@bind A1b Slider(0:0.02:2,default=1.0;show_value=true)) \
alpha1 = $(@bind d1b Slider(0:0.002:0.2,default=0.0;show_value=true)) $sp
phi1 = $(@bind ϕ1b Slider(0:0.02:6.28,default=0.0;show_value=true)) \
omega2 = $(@bind ω2b Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A2 = $(@bind A2b Slider(0:0.02:2,default=1.0;show_value=true)) \
alpha2 = $(@bind d2b Slider(0:0.002:0.2,default=0.0;show_value=true)) $sp
phi2 = $(@bind ϕ2b Slider(0:0.02:6.28,default=0.0;show_value=true)) \
omega3 = $(@bind ω3b Slider(0:0.02:3,default=1.0;show_value=true)) $sp
A3 = $(@bind A3b Slider(0:0.02:2,default=1.0;show_value=true)) \
alpha3 = $(@bind d3b Slider(0:0.002:0.2,default=0.0;show_value=true)) $sp
phi3 = $(@bind ϕ3b Slider(0:0.02:6.28,default=0.0;show_value=true)) \

Cada alpha controla que tan rapido se apaga una componente.
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
