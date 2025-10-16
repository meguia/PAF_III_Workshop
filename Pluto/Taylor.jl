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

# ╔═╡ b615a970-8f85-11ef-1c13-e9ed82dd14ce
begin
	import Pkg;
	Pkg.activate(Base.current_project());
	Pkg.instantiate();
	
	using PlutoUI, Plots, Symbolics, Latexify, LaTeXStrings
end

# ╔═╡ 8002c179-ca6f-41fc-b13b-46c5423fa3bc
@variables x a;

# ╔═╡ c5b7b753-6fd7-45fa-ac08-50cba417c3ac
md"""
# Taylor Series
Write the function here using x as a variable here without parameters.
"""	

# ╔═╡ 98ffe15a-be1f-44bb-94b8-074b8530a65b
f = sin(x);

# ╔═╡ 7fb84e83-cdf1-4fad-849d-f55a7898bb5c
dx = Differential(x);

# ╔═╡ 904864b4-b6ac-4aa6-a630-26127730bd72
begin
	dfdx = expand_derivatives(dx(f))
	dfdx2 = expand_derivatives(dx(dfdx))
	dfdx3 = expand_derivatives(dx(dfdx2))
	dfdx4 = expand_derivatives(dx(dfdx3))
	dfdx5 = expand_derivatives(dx(dfdx4))
end;

# ╔═╡ 6b5253da-78d4-4339-ba1f-85c893f1409b
begin
	f0 = substitute(f,Dict(x=>a))
	dfdx0 = substitute(dfdx,Dict(x=>a))
	dfdx20 = substitute(dfdx2,Dict(x=>a))
	dfdx30 = substitute(dfdx3,Dict(x=>a))
	dfdx40 = substitute(dfdx4,Dict(x=>a))
	dfdx50 = substitute(dfdx5,Dict(x=>a))
end;

# ╔═╡ 0a51519a-0faf-4997-b230-b79d18902b69
sp = html"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";

# ╔═╡ f95de1fa-fef7-4620-966e-e31dda738ea1
window_widget = @bind wind PlutoUI.combine() do Child
	md"""
	xmin : $(Child("x1", Slider(-4.0:0.1:-0.01,default=-3;show_value=true))) $sp
	xmax : $(Child("x2", Slider(0.01:0.1:4.0,default=3.0;show_value=true))) $sp
	ylimit : $(Child("ylimit", CheckBox())) 
	""" 
end;

# ╔═╡ 40e6ea0f-444f-4a0d-be52-fd96a8bec76d
par_widget = @bind par PlutoUI.combine() do Child
	md"""
	Then slide the value of a to evauate the Taylor expansion (up to order N) on that point \
	a : $(Child("a", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
	N : $(Child("N", Slider(0:1:5,default=1;show_value=true)))
	""" 
end;

# ╔═╡ 8f7367ae-8757-4c0a-8bb7-0e79561bc133
# TAYLOR
begin
	flist = [f0,simplify(dfdx0),simplify(dfdx20),simplify(dfdx30),simplify(dfdx40),simplify(dfdx50)]
	xlist = ["","(x-a)","\\frac{(x-a)^2}{2!}","\\frac{(x-a)^3}{3!}","\\frac{(x-a)^4}{4!}","\\frac{(x-a)^5}{5!}"]
	lstring = ""	
	ftaylor = 0
	for n = 1:par.N+1
		s1 = latexify(flist[n],env=:raw)
		if (n>1) && !(s1[2]== '-')
			lstring *= "+"
		end	
		lstring *= s1
		lstring *= xlist[n]
		ftaylor += flist[n]*(x-a)^(n-1)/factorial(n-1)
	end
	lstring *= "+..."
end;

# ╔═╡ 65db4e7d-7306-4136-a414-bb69a77f435a
tex_widget = PlutoUI.ExperimentalLayout.vbox([
		latexstring("f(x) = ",latexify(f)),
		latexstring("f(x) \\approx ",lstring),
	]);

# ╔═╡ b784972e-ac45-4cb9-9708-ef828ca079aa
begin
	fP = Symbolics.value(substitute(f, Dict(x=>par.a)))
	farr = [Symbolics.value(substitute(f, Dict(x=>y))) for y in wind.x1:0.01:wind.x2]
	maxf = maximum(farr[.!isnan.(farr)])
	minf= minimum(farr[.!isnan.(farr)])
	margin = 0.1*(maxf-minf)
	ftaylor_subs = substitute(ftaylor,Dict(a=>par.a))
	plot_widget = plot(f,label=latexify(f,env=:inline))
	plot!(ftaylor_subs,label=latexstring(lstring))
	scatter!([par.a],[fP],ms=4,c=:black,label="")
	xlims!(wind.x1,wind.x2)
	plot!([wind.x1,wind.x2],[0,0],ls=:dash,c=:black,label="")
	if wind.ylimit
		ylims!(wind.x1,wind.x2)
		plot!([0,0],[wind.x1,wind.x2],ls=:dash,c=:black,label="")
	else	
		ylims!(minf-margin,maxf+margin)
		plot!([0,0],[minf-margin,maxf+margin],ls=:dash,c=:black,label="")
	end	
	plot!(background_color_legend = RGBA(0,0,0,0.1))
	plot!(foreground_color_legend = RGBA(0,0,0,0.3))
end;

# ╔═╡ 4f828fa7-84b7-4092-b51c-fcfd5a54d9c1
begin 
	#dash_cell =  PlutoRunner.currently_running_cell_id[] |> string
	PlutoUI.ExperimentalLayout.vbox([
		tex_widget,
		par_widget,
		plot_widget,
		window_widget
	])
end

# ╔═╡ afb14697-6bef-4f7e-a39a-fd6ad82b668c
html"""
<style>
pluto-notebook {
    max-width: 1000px;
}
input[type*="range"] {
	width: 25%;
}
</style>
"""

# ╔═╡ 9796cc0f-6386-423f-8e84-aa55d88f4858
begin
	
end	

# ╔═╡ Cell order:
# ╠═b615a970-8f85-11ef-1c13-e9ed82dd14ce
# ╠═8002c179-ca6f-41fc-b13b-46c5423fa3bc
# ╠═c5b7b753-6fd7-45fa-ac08-50cba417c3ac
# ╠═98ffe15a-be1f-44bb-94b8-074b8530a65b
# ╠═4f828fa7-84b7-4092-b51c-fcfd5a54d9c1
# ╠═7fb84e83-cdf1-4fad-849d-f55a7898bb5c
# ╠═904864b4-b6ac-4aa6-a630-26127730bd72
# ╠═6b5253da-78d4-4339-ba1f-85c893f1409b
# ╠═8f7367ae-8757-4c0a-8bb7-0e79561bc133
# ╠═b784972e-ac45-4cb9-9708-ef828ca079aa
# ╠═65db4e7d-7306-4136-a414-bb69a77f435a
# ╠═40e6ea0f-444f-4a0d-be52-fd96a8bec76d
# ╠═f95de1fa-fef7-4620-966e-e31dda738ea1
# ╠═0a51519a-0faf-4997-b230-b79d18902b69
# ╠═afb14697-6bef-4f7e-a39a-fd6ad82b668c
# ╟─9796cc0f-6386-423f-8e84-aa55d88f4858
