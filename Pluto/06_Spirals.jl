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
	using Plots, PlutoUI, LaTeXStrings, PlutoEditorColorThemes, Latexify, Measures, ProjectRoot
end

# ╔═╡ 2ca3355a-58d6-4323-a697-16e486524d9a
# ╠═╡ show_logs = false
include("../iii_utils.jl");

# ╔═╡ 7e060b26-118c-445b-be90-8034517ec277
md"""
# Sum of Oscillations
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

# ╔═╡ 4e156f4c-8425-41fd-9abb-64261ab3cda2
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
	width: 20%;
}
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
	p1,p2 = plot_ntones(t1,Amps,ωs,ϕs,Amax;ncycles=ncycles)
	plot(p1,p2, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],size=(1200,400))
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
	p1b,p2b = plot_ntones_decay(t2,Ampsb,ωsb,ddb,ϕsb,Amaxb; ncycles=5)
	plot(p1b,p2b, layout=grid(1,2, widths=(1/3,2/3)), left_margin=[10mm -13mm],size=(1200,400))
end	

# ╔═╡ Cell order:
# ╟─7e060b26-118c-445b-be90-8034517ec277
# ╟─c8bf120f-b2dc-4e90-90e7-12d2fdb1c660
# ╟─0e34247d-671a-46b3-be5b-3f4545d848f0
# ╟─52f0eb33-18b6-452d-a250-65a54d96080f
# ╟─560c2913-06c2-401b-a9bc-895159fdeacd
# ╟─4542c858-9fc8-494b-9d5d-f1ad8c65791b
# ╟─9e4ea208-108c-49e2-a098-38e00a0d8fcb
# ╟─2ca3355a-58d6-4323-a697-16e486524d9a
# ╟─1f093de0-9501-11ef-30d2-4f854ecfb2e5
# ╟─4e156f4c-8425-41fd-9abb-64261ab3cda2
# ╟─18267cb1-99b8-4ed4-8558-1de0bdae4795
# ╟─e55ad533-c6ad-449c-b127-24ca36731585
