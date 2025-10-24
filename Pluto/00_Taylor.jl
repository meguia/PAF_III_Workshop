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
	
	using PlutoUI, Plots, Symbolics, Latexify, LaTeXStrings
end

# ╔═╡ 64a3716c-3d63-4b5b-8d5c-98010d47146c
# ╠═╡ show_logs = false
include("../iii_utils.jl");

# ╔═╡ c5b7b753-6fd7-45fa-ac08-50cba417c3ac
md"""
# Taylor Series

## Polynomial Functions

"""	

# ╔═╡ 9e0b5ab0-572b-4a19-bc0d-99b6597d379b
md"""
a0 = $(@bind a0 Slider(-2:0.02:2,default=0.0;show_value=true)) \
a1 = $(@bind a1 Slider(-2:0.02:2,default=1.0;show_value=true)) \
a2 = $(@bind a2 Slider(-1:0.02:1,default=0.0;show_value=true)) \
a3 = $(@bind a3 Slider(-1:0.02:1,default=0.0;show_value=true)) \
a4 = $(@bind a4 Slider(-0.2:0.01:0.2,default=0.0;show_value=true)) \
a5 = $(@bind a5 Slider(-0.1:0.005:0.1,default=0.0;show_value=true)) 
"""

# ╔═╡ a4e0dcac-7872-4fdd-a808-f4ca8e9fbe13
md"""
## Trigonometric and Exponential Functions

Choose the function here using x as a variable here without parameters.

"""

# ╔═╡ 8002c179-ca6f-41fc-b13b-46c5423fa3bc
@variables x a;

# ╔═╡ 98ffe15a-be1f-44bb-94b8-074b8530a65b
@bind f Select([sin(x), cos(x), exp(x)])

# ╔═╡ dc8573e0-89d6-48cd-ae1c-b57cdd4d63a2
f2 = a0+a1*x+a2*x^2+a3*x^3+a4*x^4+a5*x^5;

# ╔═╡ afb14697-6bef-4f7e-a39a-fd6ad82b668c
html"""
<style>
pluto-notebook {
    max-width: 1000px;
}
input[type*="range"] {
	width: 25%;
}
pluto-helpbox { display: none; } 
</style>
"""

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

# ╔═╡ 508c5ff8-add4-4da8-94ac-0590dd4fc971
plot_widget, lstring = taylor_plot5(f,x,par.a,par.N,wind.x1,wind.x2,wind.ylimit);

# ╔═╡ 6474ee92-dfde-4531-8a72-ed455ee24fa3
tex_widget = PlutoUI.ExperimentalLayout.vbox([
		latexstring("f(x) = ",latexify(f)),
		latexstring("f(x) \\approx ",lstring),
	]);

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

# ╔═╡ 5ee2f847-8755-446a-b3b8-04e6b9bec084
par_widget2 = @bind par2 PlutoUI.combine() do Child
	md"""
	Then slide the value of a to evauate the Taylor expansion (up to order N) on that point \
	a : $(Child("a", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
	N : $(Child("N", Slider(0:1:5,default=1;show_value=true)))
	""" 
end;

# ╔═╡ 5ce2cabf-2498-4626-93d8-881a7700cd65
window_widget2 = @bind wind2 PlutoUI.combine() do Child
	md"""
	xmin : $(Child("x1", Slider(-4.0:0.1:-0.01,default=-3;show_value=true))) $sp
	xmax : $(Child("x2", Slider(0.01:0.1:4.0,default=3.0;show_value=true))) $sp
	ylimit : $(Child("ylimit", CheckBox())) 
	""" 
end;

# ╔═╡ 4e36776a-be45-457d-8310-d49f27769b7b
plot_widget2, lstring2 = taylor_plot5(f2,x,par2.a,par2.N,wind2.x1,wind2.x2,wind2.ylimit);

# ╔═╡ cc5c2da0-e003-4fa4-a59a-5b5bb49421bd
tex_widget2 = PlutoUI.ExperimentalLayout.vbox([
		latexstring("f(x) = ",latexify(f2)),
		latexstring("f(x) \\approx ",lstring2),
	]);

# ╔═╡ 9a6f56c3-7bf3-4eaf-a299-3be78b3b7442
begin 
	#dash_cell =  PlutoRunner.currently_running_cell_id[] |> string
	PlutoUI.ExperimentalLayout.vbox([
		tex_widget2,
		par_widget2,
		plot_widget2,
		window_widget2
	])
end

# ╔═╡ Cell order:
# ╟─c5b7b753-6fd7-45fa-ac08-50cba417c3ac
# ╟─9e0b5ab0-572b-4a19-bc0d-99b6597d379b
# ╟─9a6f56c3-7bf3-4eaf-a299-3be78b3b7442
# ╟─4e36776a-be45-457d-8310-d49f27769b7b
# ╟─a4e0dcac-7872-4fdd-a808-f4ca8e9fbe13
# ╟─98ffe15a-be1f-44bb-94b8-074b8530a65b
# ╟─4f828fa7-84b7-4092-b51c-fcfd5a54d9c1
# ╟─dc8573e0-89d6-48cd-ae1c-b57cdd4d63a2
# ╟─8002c179-ca6f-41fc-b13b-46c5423fa3bc
# ╟─508c5ff8-add4-4da8-94ac-0590dd4fc971
# ╟─40e6ea0f-444f-4a0d-be52-fd96a8bec76d
# ╟─5ee2f847-8755-446a-b3b8-04e6b9bec084
# ╟─f95de1fa-fef7-4620-966e-e31dda738ea1
# ╟─5ce2cabf-2498-4626-93d8-881a7700cd65
# ╟─cc5c2da0-e003-4fa4-a59a-5b5bb49421bd
# ╟─6474ee92-dfde-4531-8a72-ed455ee24fa3
# ╟─b615a970-8f85-11ef-1c13-e9ed82dd14ce
# ╟─64a3716c-3d63-4b5b-8d5c-98010d47146c
# ╟─afb14697-6bef-4f7e-a39a-fd6ad82b668c
# ╟─0a51519a-0faf-4997-b230-b79d18902b69
