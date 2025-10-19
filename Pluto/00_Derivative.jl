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
# ╠═╡ show_logs = false
begin
	import Pkg;
	Pkg.activate(Base.current_project());
	Pkg.instantiate();
	
	using PlutoUI, Plots, Symbolics, Latexify, LaTeXStrings;
end

# ╔═╡ fcf313fe-afda-459e-91c8-f8ffa019eb86
# ╠═╡ show_logs = false
include("../iii_utils.jl");

# ╔═╡ c5b7b753-6fd7-45fa-ac08-50cba417c3ac
md"""
# Derivative 

## Polynomial Functions
"""	

# ╔═╡ 98ffe15a-be1f-44bb-94b8-074b8530a65b
md"""
a0 = $(@bind a0 Slider(-2:0.02:2,default=0.0;show_value=true)) \
a1 = $(@bind a1 Slider(-2:0.02:2,default=1.0;show_value=true)) \
a2 = $(@bind a2 Slider(-1:0.02:1,default=0.0;show_value=true)) \
a3 = $(@bind a3 Slider(-1:0.02:1,default=0.0;show_value=true)) \
a4 = $(@bind a4 Slider(-0.2:0.01:0.2,default=0.0;show_value=true)) \
a5 = $(@bind a5 Slider(-0.1:0.005:0.1,default=0.0;show_value=true)) 
"""

# ╔═╡ f0d4d3f0-8c96-4b35-9815-eac5f1d1649f
md"""
## Trigonometric and Exponential Functions

Choose the function here using x as a variable here without parameters.

"""

# ╔═╡ 8002c179-ca6f-41fc-b13b-46c5423fa3bc
@variables x;

# ╔═╡ 6d9b5e19-ede8-40dc-b90d-2286f7697898
@bind f2 Select([sin(x), cos(x), exp(x)])

# ╔═╡ 9f1cc852-1b38-4e33-b868-2e221424cbb5
f = a0+a1*x+a2*x^2+a3*x^3+a4*x^4+a5*x^5;

# ╔═╡ 7fb84e83-cdf1-4fad-849d-f55a7898bb5c
dx = Differential(x);

# ╔═╡ 904864b4-b6ac-4aa6-a630-26127730bd72
dfdx = simplify(expand_derivatives(dx(f)));

# ╔═╡ 679c3188-4930-4364-8f56-6a2d0a688c37
dfdx2 = simplify(expand_derivatives(dx(f2)));

# ╔═╡ 65db4e7d-7306-4136-a414-bb69a77f435a
tex_widget = PlutoUI.ExperimentalLayout.vbox([
		latexstring("f(x) = ",latexify(f)),
		latexstring("\\frac{df}{dx}(x) = ",latexify(dfdx))
	]);

# ╔═╡ 1e4dd018-1bca-446d-ab21-029a5944b5e9
tex_widget2 = PlutoUI.ExperimentalLayout.vbox([
		latexstring("f(x) = ",latexify(f2)),
		latexstring("\\frac{df}{dx}(x) = ",latexify(dfdx2))
	]);

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

# ╔═╡ 39cb292d-4b3e-47b2-818b-e476bfe1f96b
par_widget = @bind par PlutoUI.combine() do Child
	md"""
	Then slide the value of a to evauate the Derivative (up to order N) on that point \
	a : $(Child("a", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
	N : $(Child("N", Slider(0:1:5,default=0;show_value=true)))
	tangent : $(Child("tangent", CheckBox())) 
	""" 
end;

# ╔═╡ 36aedde5-55ee-4c2d-b376-c48873796224
plot_widget = plot_derivative(f,x,par.a,par.N,wind.x1,wind.x2,wind.ylimit,par.tangent);

# ╔═╡ f81b743d-3039-4548-a539-9b0d52f85e6c
begin 
	#dash_cell =  PlutoRunner.currently_running_cell_id[] |> string
	PlutoUI.ExperimentalLayout.vbox([
		tex_widget,
		par_widget,
		plot_widget,
		window_widget
	])
end

# ╔═╡ 3fc151bc-ca62-4271-8b0d-6bdb97b5c112
par_widget2 = @bind par2 PlutoUI.combine() do Child
	md"""
	Then slide the value of a to evauate the Derivative (up to order N) on that point \
	a : $(Child("a", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
	N : $(Child("N", Slider(0:1:5,default=0;show_value=true)))
	tangent : $(Child("tangent", CheckBox()))
	""" 
end;

# ╔═╡ 2f8118f7-e946-4cb2-9243-17c6450c40fc
window_widget2 = @bind wind2 PlutoUI.combine() do Child
	md"""
	xmin : $(Child("x1", Slider(-4.0:0.1:-0.01,default=-3;show_value=true))) $sp
	xmax : $(Child("x2", Slider(0.01:0.1:4.0,default=3.0;show_value=true))) $sp
	ylimit : $(Child("ylimit", CheckBox())) 
	""" 
end;

# ╔═╡ c0ab9c85-6e48-4892-afcd-50530ff1925d
plot_widget2 = plot_derivative(f2,x,par2.a,par2.N,wind2.x1,wind2.x2,wind2.ylimit,par2.tangent);

# ╔═╡ fee8169e-2aeb-485b-b2b1-53faa2133cf4
begin 
	#dash_cell =  PlutoRunner.currently_running_cell_id[] |> string
	PlutoUI.ExperimentalLayout.vbox([
		tex_widget2,
		par_widget2,
		plot_widget2,
		window_widget2
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
# ╟─c5b7b753-6fd7-45fa-ac08-50cba417c3ac
# ╟─98ffe15a-be1f-44bb-94b8-074b8530a65b
# ╟─f81b743d-3039-4548-a539-9b0d52f85e6c
# ╟─f0d4d3f0-8c96-4b35-9815-eac5f1d1649f
# ╟─6d9b5e19-ede8-40dc-b90d-2286f7697898
# ╟─fee8169e-2aeb-485b-b2b1-53faa2133cf4
# ╟─8002c179-ca6f-41fc-b13b-46c5423fa3bc
# ╟─9f1cc852-1b38-4e33-b868-2e221424cbb5
# ╟─36aedde5-55ee-4c2d-b376-c48873796224
# ╟─c0ab9c85-6e48-4892-afcd-50530ff1925d
# ╟─7fb84e83-cdf1-4fad-849d-f55a7898bb5c
# ╟─904864b4-b6ac-4aa6-a630-26127730bd72
# ╟─679c3188-4930-4364-8f56-6a2d0a688c37
# ╟─65db4e7d-7306-4136-a414-bb69a77f435a
# ╟─1e4dd018-1bca-446d-ab21-029a5944b5e9
# ╟─fcf313fe-afda-459e-91c8-f8ffa019eb86
# ╟─39cb292d-4b3e-47b2-818b-e476bfe1f96b
# ╟─3fc151bc-ca62-4271-8b0d-6bdb97b5c112
# ╟─f95de1fa-fef7-4620-966e-e31dda738ea1
# ╟─2f8118f7-e946-4cb2-9243-17c6450c40fc
# ╟─b615a970-8f85-11ef-1c13-e9ed82dd14ce
# ╟─0a51519a-0faf-4997-b230-b79d18902b69
# ╟─afb14697-6bef-4f7e-a39a-fd6ad82b668c
