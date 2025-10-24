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

# ╔═╡ 6d9b5e19-ede8-40dc-b90d-2286f7697898
@bind f2n Select(["sin(ax)", "cos(ax)", "exp(ax)"])

# ╔═╡ ba931c34-2693-4955-bd43-0e3489b99cd5
md"""
## Arbitrary Functions

Write the function here using x as a variable here.

"""

# ╔═╡ 8002c179-ca6f-41fc-b13b-46c5423fa3bc
@variables x;

# ╔═╡ 9f1cc852-1b38-4e33-b868-2e221424cbb5
f = a0+a1*x+a2*x^2+a3*x^3+a4*x^4+a5*x^5;

# ╔═╡ 65db4e7d-7306-4136-a414-bb69a77f435a
function text_widget(f,N)
	dx = Differential(x);
	dfdx = expand_derivatives(dx(f))
	dfdx2 = expand_derivatives(dx(dfdx))
	dfdx3 = expand_derivatives(dx(dfdx2))
	dfdx4 = expand_derivatives(dx(dfdx3))
	dfdx5 = expand_derivatives(dx(dfdx4))
	textlist = [latexstring("f(x) = ",latexify(f))]
	if N>0
		push!(textlist,latexstring("\\frac{df}{dx}(x) = ",latexify(dfdx)))
	end	
	if N>1
		push!(textlist,latexstring("\\frac{d^2f}{dx^2}(x) = ",latexify(dfdx2)))
	end	
	if N>2
		push!(textlist,latexstring("\\frac{d^3f}{dx^3}(x) = ",latexify(dfdx3)))
	end	
	if N>3
		push!(textlist,latexstring("\\frac{d^4f}{dx^4}(x) = ",latexify(dfdx4)))
	end	
	if N>4
		push!(textlist,latexstring("\\frac{d^5f}{dx^5}(x) = ",latexify(dfdx5)))
	end	
	return PlutoUI.ExperimentalLayout.vbox(textlist)
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

# ╔═╡ 39cb292d-4b3e-47b2-818b-e476bfe1f96b
par_widget = @bind par PlutoUI.combine() do Child
	md"""
	Then slide the value of a to evauate the Derivative (up to order N) on that point \
	x₀ : $(Child("x0", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
	N : $(Child("N", Slider(0:1:5,default=0;show_value=true)))
	tangent : $(Child("tangent", CheckBox())) 
	""" 
end;

# ╔═╡ 36aedde5-55ee-4c2d-b376-c48873796224
plot_widget = plot_derivative(f,x,par.x0,par.N,wind.x1,wind.x2,wind.ylimit,par.tangent);

# ╔═╡ f81b743d-3039-4548-a539-9b0d52f85e6c
begin 
	#dash_cell =  PlutoRunner.currently_running_cell_id[] |> string
	PlutoUI.ExperimentalLayout.vbox([
		text_widget(f,par.N),
		par_widget,
		plot_widget,
		window_widget
	])
end

# ╔═╡ 3fc151bc-ca62-4271-8b0d-6bdb97b5c112
par_widget2 = @bind par2 PlutoUI.combine() do Child
	md"""
	Then slide the value of a to evauate the Derivative (up to order N) on that point \
	a : $(Child("a", Slider(-1:0.1:1,default=1.0;show_value=true))) \
	x₀ : $(Child("x0", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
	N : $(Child("N", Slider(0:1:5,default=0;show_value=true)))
	tangent : $(Child("tangent", CheckBox()))
	""" 
end;

# ╔═╡ 08285973-9fac-49c6-8790-5ed0cc9e40aa
begin
	if f2n=="sin(ax)"
		f2 = sin(par2.a*x)
	elseif f2n=="cos(ax)"
		f2 = cos(par2.a*x)
	elseif f2n=="exp(ax)"
		f2 = exp(par2.a*x)
	end
end;

# ╔═╡ 27a33e48-ec94-46bb-8272-4002372174c5
par_widget3 = @bind par3 PlutoUI.combine() do Child
	md"""
	Then slide the value of a to evauate the Derivative (up to order N) on that point \
	a : $(Child("a", Slider(-1:0.1:1,default=1.0;show_value=true))) \
	x₀ : $(Child("x0", Slider(wind.x1:0.01:wind.x2,default=1.0;show_value=true))) $sp
	N : $(Child("N", Slider(0:1:5,default=0;show_value=true)))
	tangent : $(Child("tangent", CheckBox()))
	""" 
end;

# ╔═╡ 49cbf592-bf62-48cd-a56c-7e4402212349
f3 = cos(par3.a*x)^2

# ╔═╡ 529bde27-9d2c-4333-b1a7-6266127333f8
window_widget3 = @bind wind3 PlutoUI.combine() do Child
	md"""
	xmin : $(Child("x1", Slider(-4.0:0.1:-0.01,default=-3;show_value=true))) $sp
	xmax : $(Child("x2", Slider(0.01:0.1:4.0,default=3.0;show_value=true))) $sp
	ylimit : $(Child("ylimit", CheckBox())) 
	""" 
end;

# ╔═╡ 26080fb1-2e32-4f63-b391-9199a33d2191
plot_widget3 = plot_derivative(f3,x,par3.x0,par3.N,wind3.x1,wind3.x2,wind3.ylimit,par3.tangent);

# ╔═╡ 6e6bfd74-382d-4f0e-8158-36f06d94dbbb
begin 
	#dash_cell =  PlutoRunner.currently_running_cell_id[] |> string
	PlutoUI.ExperimentalLayout.vbox([
		text_widget(f3,par3.N),
		par_widget3,
		plot_widget3,
		window_widget3
	])
end

# ╔═╡ 2f8118f7-e946-4cb2-9243-17c6450c40fc
window_widget2 = @bind wind2 PlutoUI.combine() do Child
	md"""
	xmin : $(Child("x1", Slider(-4.0:0.1:-0.01,default=-3;show_value=true))) $sp
	xmax : $(Child("x2", Slider(0.01:0.1:4.0,default=3.0;show_value=true))) $sp
	ylimit : $(Child("ylimit", CheckBox())) 
	""" 
end;

# ╔═╡ c0ab9c85-6e48-4892-afcd-50530ff1925d
plot_widget2 = plot_derivative(f2,x,par2.x0,par2.N,wind2.x1,wind2.x2,wind2.ylimit,par2.tangent);

# ╔═╡ fee8169e-2aeb-485b-b2b1-53faa2133cf4
begin 
	#dash_cell =  PlutoRunner.currently_running_cell_id[] |> string
	PlutoUI.ExperimentalLayout.vbox([
		text_widget(f2,par2.N),
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
pluto-helpbox { display: none; } 
</style>
"""

# ╔═╡ Cell order:
# ╟─c5b7b753-6fd7-45fa-ac08-50cba417c3ac
# ╟─98ffe15a-be1f-44bb-94b8-074b8530a65b
# ╟─f81b743d-3039-4548-a539-9b0d52f85e6c
# ╟─f0d4d3f0-8c96-4b35-9815-eac5f1d1649f
# ╟─6d9b5e19-ede8-40dc-b90d-2286f7697898
# ╟─fee8169e-2aeb-485b-b2b1-53faa2133cf4
# ╟─ba931c34-2693-4955-bd43-0e3489b99cd5
# ╟─49cbf592-bf62-48cd-a56c-7e4402212349
# ╟─6e6bfd74-382d-4f0e-8158-36f06d94dbbb
# ╟─8002c179-ca6f-41fc-b13b-46c5423fa3bc
# ╟─9f1cc852-1b38-4e33-b868-2e221424cbb5
# ╟─08285973-9fac-49c6-8790-5ed0cc9e40aa
# ╟─36aedde5-55ee-4c2d-b376-c48873796224
# ╟─c0ab9c85-6e48-4892-afcd-50530ff1925d
# ╟─26080fb1-2e32-4f63-b391-9199a33d2191
# ╟─65db4e7d-7306-4136-a414-bb69a77f435a
# ╟─39cb292d-4b3e-47b2-818b-e476bfe1f96b
# ╟─3fc151bc-ca62-4271-8b0d-6bdb97b5c112
# ╟─27a33e48-ec94-46bb-8272-4002372174c5
# ╟─f95de1fa-fef7-4620-966e-e31dda738ea1
# ╟─529bde27-9d2c-4333-b1a7-6266127333f8
# ╟─fcf313fe-afda-459e-91c8-f8ffa019eb86
# ╟─2f8118f7-e946-4cb2-9243-17c6450c40fc
# ╟─b615a970-8f85-11ef-1c13-e9ed82dd14ce
# ╟─0a51519a-0faf-4997-b230-b79d18902b69
# ╟─afb14697-6bef-4f7e-a39a-fd6ad82b668c
