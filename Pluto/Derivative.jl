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
	
	using PlutoUI, Plots, Symbolics, Latexify, LaTeXStrings;
end

# ╔═╡ 8002c179-ca6f-41fc-b13b-46c5423fa3bc
@variables x a b c;

# ╔═╡ c5b7b753-6fd7-45fa-ac08-50cba417c3ac
md"""
# Derivative 
write the function here using x as a variable here with up to three parameters: a, b ,c
for example f=a*x^2+bx+c
"""	

# ╔═╡ 98ffe15a-be1f-44bb-94b8-074b8530a65b
f = sin(a*x);

# ╔═╡ 7fb84e83-cdf1-4fad-849d-f55a7898bb5c
dx = Differential(x);

# ╔═╡ 904864b4-b6ac-4aa6-a630-26127730bd72
dfdx = simplify(expand_derivatives(dx(f)));

# ╔═╡ 6dddcd75-96df-4fab-be2b-1728f268adf5
npars = size(Symbolics.get_variables(f))[1]-1;

# ╔═╡ 65db4e7d-7306-4136-a414-bb69a77f435a
tex_widget = PlutoUI.ExperimentalLayout.vbox([
		latexstring("f(x) = ",latexify(f)),
		latexstring("\\frac{df}{dx}(x) = ",latexify(dfdx))
	]);

# ╔═╡ ca01ea8f-4b35-4971-af37-31fbeaaa6762
par_range = 0.01:0.01:1.0;

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

# ╔═╡ e77f1171-c489-4a81-849a-16e107b3bb50
if size(Symbolics.get_variables(f))[1] == 2
	par_widget = @bind par PlutoUI.combine() do Child
		md"""
		a : $(Child("a", Slider(par_range,default=0.1;show_value=true))) \
		P : $(Child("P", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
		plot derivative : $(Child("plotd", CheckBox()))
		""" 
	end;
elseif size(Symbolics.get_variables(f))[1] == 3
	par_widget = @bind par PlutoUI.combine() do Child
		md"""
		a : $(Child("a", Slider(par_range,default=0.1;show_value=true))) $sp
		b : $(Child("b", Slider(par_range,default=0.1;show_value=true))) \
		P : $(Child("P", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
		plot derivative : $(Child("plotd", CheckBox()))
		""" 
	end;
elseif size(Symbolics.get_variables(f))[1] == 4
	par_widget = @bind par PlutoUI.combine() do Child
		md"""
		a : $(Child("a", Slider(par_range,default=0.1;show_value=true))) $sp
		b : $(Child("b", Slider(par_range,default=0.1;show_value=true))) $sp
		c : $(Child("c", Slider(par_range,default=0.1;show_value=true))) \
		P : $(Child("P", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
		plot derivative : $(Child("plotd", CheckBox()))
		""" 
	end;
end;

# ╔═╡ b654e63f-6d00-439a-9c12-3260e38a2b56
begin
	if npars==1
		f_subs = substitute(f, Dict(a=>par.a))
		dfdx_subs = substitute(dfdx, Dict(a=>par.a))
	elseif npars==2	
		f_subs = substitute(f, Dict(a=>par.a,b=>par.b))
		dfdx_subs = substitute(dfdx, Dict(a=>par.a,b=>par.b))
	elseif npars==3	
		f_subs = substitute(f, Dict(a=>par.a,b=>par.b,c=>par.c))
		dfdx_subs = substitute(dfdx, Dict(a=>par.a,b=>par.b,c=>par.c))
	end	
	sP = Symbolics.value(substitute(dfdx_subs, Dict(x=>par.P)))
	fP = Symbolics.value(substitute(f_subs, Dict(x=>par.P)))
	TP = fP + sP*(x-par.P)
end;

# ╔═╡ 7ceea0d1-8939-4b3b-bf2b-a1b1760cfa4a
begin
	plot_widget = plot(f_subs,label=latexify(f_subs,env=:inline))
	plot!(TP,c=:red,label=latexify("tangent"))
	scatter!([par.P],[fP],ms=4,c=:black,label="")
	annotate!(par.P+0.5, fP, latexify(string(round(sP,sigdigits=3))), :red)
	if (par.plotd)
		plot!(dfdx_subs,c=:red,ls=:dash,label=latexify(dfdx_subs,env=:inline))
		dfdxP = Symbolics.value(substitute(dfdx_subs, Dict(x=>par.P)))
		scatter!([par.P],[dfdxP],ms=3,c=:red,label="")
	end
	farr = [Symbolics.value(substitute(f_subs, Dict(x=>y))) for y in wind.x1:0.01:wind.x2]
	maxf = maximum(farr[.!isnan.(farr)])
	minf= minimum(farr[.!isnan.(farr)])
	margin = 0.1*(maxf-minf)
	plot!([wind.x1,wind.x2],[0,0],ls=:dash,c=:black,label="")
	xlims!(wind.x1,wind.x2)
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

# ╔═╡ 935cb98a-7268-4de1-86f4-24b7dd1b5549
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

# ╔═╡ Cell order:
# ╟─b615a970-8f85-11ef-1c13-e9ed82dd14ce
# ╠═8002c179-ca6f-41fc-b13b-46c5423fa3bc
# ╟─c5b7b753-6fd7-45fa-ac08-50cba417c3ac
# ╠═98ffe15a-be1f-44bb-94b8-074b8530a65b
# ╟─935cb98a-7268-4de1-86f4-24b7dd1b5549
# ╠═7fb84e83-cdf1-4fad-849d-f55a7898bb5c
# ╠═904864b4-b6ac-4aa6-a630-26127730bd72
# ╠═6dddcd75-96df-4fab-be2b-1728f268adf5
# ╠═65db4e7d-7306-4136-a414-bb69a77f435a
# ╠═b654e63f-6d00-439a-9c12-3260e38a2b56
# ╠═7ceea0d1-8939-4b3b-bf2b-a1b1760cfa4a
# ╠═e77f1171-c489-4a81-849a-16e107b3bb50
# ╠═f95de1fa-fef7-4620-966e-e31dda738ea1
# ╠═ca01ea8f-4b35-4971-af37-31fbeaaa6762
# ╟─0a51519a-0faf-4997-b230-b79d18902b69
# ╟─afb14697-6bef-4f7e-a39a-fd6ad82b668c
