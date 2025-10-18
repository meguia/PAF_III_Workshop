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
@variables x y a b c;

# ╔═╡ c5b7b753-6fd7-45fa-ac08-50cba417c3ac
md"""
# Gradient
write the function here using x, y as variables here with up to three parameters: a, b ,c
for example f=a*x^2+bx+c
"""	

# ╔═╡ 98ffe15a-be1f-44bb-94b8-074b8530a65b
f = cos(a*x)+sin(b*y);

# ╔═╡ f7cbafea-45ec-47ec-bde9-387c6d3522f5
npars = size(Symbolics.get_variables(f))[1]-2;

# ╔═╡ 9103bad6-cc47-403f-9a48-1febd1263e0a
begin
	dx = Differential(x);
	dy = Differential(y);
	dfdx = simplify(expand_derivatives(dx(f)))
	dfdy = simplify(expand_derivatives(dy(f)))
end;

# ╔═╡ cf42d6df-a420-4991-b8c5-557ab8304bfb
begin
	xspan = -2:0.05:2
	yspan = -2:0.05:2
	xgrid = -2:0.25:2
	ygrid = -2:0.25:2
	X = xgrid'.*ones(size(ygrid))
	Y = ones(size(xgrid))'.*ygrid
end;

# ╔═╡ ca01ea8f-4b35-4971-af37-31fbeaaa6762
par_range = 0.01:0.01:1.0;

# ╔═╡ 0a51519a-0faf-4997-b230-b79d18902b69
sp = html"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";

# ╔═╡ 76d19097-f961-4049-b080-32cc7ae96c38
if npars == 1
	par_widget = @bind par PlutoUI.combine() do Child
		md"""
		a : $(Child("a", Slider(par_range,default=0.1;show_value=true))) \
		x0 : $(Child("x0", Slider(xspan,default=1.0;show_value=true))) $sp
		y0 : $(Child("y0", Slider(yspan,default=1.0;show_value=true))) $sp
		gradient : $(Child("plotg", CheckBox()))
		""" 
	end;
elseif npars == 2
	par_widget = @bind par PlutoUI.combine() do Child
		md"""
		a : $(Child("a", Slider(par_range,default=0.1;show_value=true))) $sp
		b : $(Child("b", Slider(par_range,default=0.1;show_value=true))) \
		x0 : $(Child("x0", Slider(xspan,default=1.0;show_value=true))) $sp
		y0 : $(Child("y0", Slider(yspan,default=1.0;show_value=true))) $sp
		gradient : $(Child("plotg", CheckBox()))
		""" 
	end;
elseif npars == 3
	par_widget = @bind par PlutoUI.combine() do Child
		md"""
		a : $(Child("a", Slider(par_range,default=0.1;show_value=true))) $sp
		b : $(Child("b", Slider(par_range,default=0.1;show_value=true))) $sp
		c : $(Child("c", Slider(par_range,default=0.1;show_value=true))) \
		x0 : $(Child("x0", Slider(xspan,default=1.0;show_value=true))) $sp
		y0 : $(Child("y0", Slider(yspan,default=1.0;show_value=true))) $sp
		gradient : $(Child("plotg", CheckBox()))
		""" 
	end;
end;

# ╔═╡ 611c948a-bc32-4d6b-b1be-b918a6b42276
begin
	if npars==1
		f_subs = substitute(f, Dict(a=>par.a))
		dfdx_subs = substitute(dfdx, Dict(a=>par.a))
		dfdy_subs = substitute(dfdy, Dict(a=>par.a))
	elseif npars==2	
		f_subs = substitute(f, Dict(a=>par.a,b=>par.b))
		dfdx_subs = substitute(dfdx, Dict(a=>par.a,b=>par.b))
		dfdy_subs = substitute(dfdy, Dict(a=>par.a,b=>par.b))
	elseif npars==3	
		f_subs = substitute(f, Dict(a=>par.a,b=>par.b,c=>par.c))
		dfdx_subs = substitute(dfdx, Dict(a=>par.a,b=>par.b,c=>par.c))
		dfdy_subs = substitute(dfdy, Dict(a=>par.a,b=>par.b,c=>par.c))
	end
	fxgrid = Symbolics.value(substitute(dfdx_subs, Dict(x=>X,y=>Y)))
	fygrid = Symbolics.value(substitute(dfdy_subs, Dict(x=>X,y=>Y)))
	maxg = maximum(hcat(fygrid,fxgrid))
end;

# ╔═╡ d0bfc4fc-2b71-4d51-b4e4-185f7458cbda
begin 
	fP = Symbolics.value(substitute(f_subs, Dict(x=>par.x0,y=>par.y0)))
	fx = Symbolics.value(substitute(dfdx_subs, Dict(x=>par.x0,y=>par.y0)))
	fy = Symbolics.value(substitute(dfdy_subs, Dict(x=>par.x0,y=>par.y0)))
	TP  = fP + fx*(x-par.x0)+fy*(y-par.y0)
	fxarr = [Symbolics.value(substitute(dfdx_subs, Dict(x=>x1,y=>y1))) for y1 in ygrid for x1 in xgrid]
	fyarr = [Symbolics.value(substitute(dfdy_subs, Dict(x=>x1,y=>y1))) for y1 in ygrid for x1 in xgrid]
end;

# ╔═╡ b4887687-723d-4dbc-ae73-e6088005d204
tex_widget = PlutoUI.ExperimentalLayout.vbox([
		latexstring("f(x) = ",latexify(f)),
		latexstring("\\textcolor{green}{\\frac{\\partial f}{\\partial x}(x) = ",latexify(dfdx),"=",string(round(fx,sigdigits=3)), "}"),
		latexstring("\\textcolor{red}{\\frac{\\partial f}{\\partial y}(x) = ",latexify(dfdy),"=",string(round(fy,sigdigits=3)),"}")
	]);

# ╔═╡ 4f102501-0090-4dd0-9eb1-7ce7edd3b3e6
window_widget = @bind wind PlutoUI.combine() do Child
	md"""
	s : $(Child("scale", Slider(-4:4,default=0;show_value=true))) $sp
	""" 
end;

# ╔═╡ b579f0cf-20da-4872-9648-231ec6319e85
begin
	s = 0.5*2.0^(wind.scale)/maxg
	plot_widget = contourf(xspan,yspan,f_subs,c=:heat,xlabel="x",ylabel="y")
	if (par.plotg)
		quiver!(X,Y, quiver=(fxgrid*s, fygrid*s),c=RGBA(0,0,0,0.1))
	end	
	scatter!([par.x0],[par.y0],c=:black,label="")
	quiver!([par.x0],[par.y0], quiver=([fx*s], [0]),c=:green)
	quiver!([par.x0],[par.y0], quiver=([0], [fy*s]),c=:red)
	quiver!([par.x0],[par.y0], quiver=([fx*s], [fy*s]),c=:black)
	plot!(colorbar=true,aspect_ratio=:equal,size=(500,500))
end;

# ╔═╡ 935cb98a-7268-4de1-86f4-24b7dd1b5549
begin 
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
	width: 23%;
}
</style>
"""

# ╔═╡ Cell order:
# ╟─b615a970-8f85-11ef-1c13-e9ed82dd14ce
# ╠═8002c179-ca6f-41fc-b13b-46c5423fa3bc
# ╟─c5b7b753-6fd7-45fa-ac08-50cba417c3ac
# ╠═98ffe15a-be1f-44bb-94b8-074b8530a65b
# ╟─935cb98a-7268-4de1-86f4-24b7dd1b5549
# ╟─f7cbafea-45ec-47ec-bde9-387c6d3522f5
# ╟─9103bad6-cc47-403f-9a48-1febd1263e0a
# ╠═b4887687-723d-4dbc-ae73-e6088005d204
# ╠═611c948a-bc32-4d6b-b1be-b918a6b42276
# ╠═b579f0cf-20da-4872-9648-231ec6319e85
# ╠═cf42d6df-a420-4991-b8c5-557ab8304bfb
# ╠═d0bfc4fc-2b71-4d51-b4e4-185f7458cbda
# ╠═76d19097-f961-4049-b080-32cc7ae96c38
# ╠═4f102501-0090-4dd0-9eb1-7ce7edd3b3e6
# ╠═ca01ea8f-4b35-4971-af37-31fbeaaa6762
# ╟─0a51519a-0faf-4997-b230-b79d18902b69
# ╟─afb14697-6bef-4f7e-a39a-fd6ad82b668c
