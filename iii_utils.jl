begin
    import Pkg;

    Pkg.activate(Base.current_project());
    Pkg.instantiate();

    using Plots, LaTeXStrings, Symbolics
end

gr()  # set GR as the default backend for Plots

"""
    plot_numberline(xmin, xmax;
        arrow_to::Union{Nothing, Real} = nothing,
        arrowcolor = :red,
        linecolor = :black,
        labelcolor = :black,
        fontsize::Int = 10,
        width::Int = 1200,
        height::Int = 300,
        show_decimals::Bool = true,
        dec_color = :gray,
        dec_fontsize::Int = 9)

Draw a horizontal number line from `xmin` to `xmax` with integer-only ticks.
Integers show as 5, not 5.0. If the visible range is < 5 and
`show_decimals` is true, add shorter gray decimal ticks (and labels)
using a step chosen from (0.5, 0.25, 0.1) to keep total decimal ticks in [5, 20].
Optionally draw an arrow from 0 to `arrow_to`.
"""
function plot_numberline(xmin::Real, xmax::Real;
    arrow_to::Union{Nothing, Real} = nothing,
    arrowcolor = :red,
    linecolor = :black,
    labelcolor = :black,
    fontsize::Int = 10,
    width::Int = 1200,
    height::Int = 300,
    show_decimals::Bool = true,
    dec_color = :gray,
    dec_fontsize::Int = 9)

    x1, x2 = float(min(xmin, xmax)), float(max(xmin, xmax))
    rng = x2 - x1
    rng ≤ 0 && error("xmin must be < xmax")

    #  integer ticks (primary)
    L = ceil(Int, x1)
    R = floor(Int, x2)

    count_with_step(L,R,k::Int) = (R < L) ? 0 : (R ÷ k - cld(L, k) + 1)

    function choose_int_step(L,R)
        if R < L
            return 1
        end
        if (R - L + 1) ≤ 50
            return 1
        end
        for s in (2, 5, 10, 20, 50, 100, 200, 500, 1000)
            count_with_step(L,R,s) ≤ 50 && return s
        end
        return 1000
    end

    step_int = choose_int_step(L, R)

    if R ≥ L
        tstart = cld(L, step_int) * step_int
        tend   = (R ÷ step_int) * step_int
        ticksI = collect(tstart:step_int:tend)
        labelsI = string.(Int.(ticksI))
    else
        ticksI  = Int[]
        labelsI = String[]
    end

    ticksD  = Float64[]
    labelsD = String[]
    if rng < 5 && show_decimals
        # choose decimal step to keep 5..20 decimal ticks
        for s in (0.5, 0.25, 0.1)
            t0 = ceil(x1/s)*s
            t1 = floor(x2/s)*s
            c  = (t0 ≤ t1) ? Int(round((t1 - t0)/s)) + 1 : 0
            if 5 ≤ c ≤ 20
                # build and filter out integers to avoid doubling
                raw = collect(t0:s:t1)
                ticksD = [t for t in raw if !isapprox(t, round(t); atol=1e-10)]
                digits = max(1, ceil(Int, -log10(s)))
                labelsD = string.(round.(ticksD, digits=digits))
                break
            end
        end
        # fallback if none matched (tiny range)
        if isempty(ticksD)
            s = 0.1
            t0 = ceil(x1/s)*s
            t1 = floor(x2/s)*s
            raw = t0 ≤ t1 ? collect(t0:s:t1) : Float64[]
            ticksD = [t for t in raw if !isapprox(t, round(t); atol=1e-10)]
            labelsD = string.(round.(ticksD, digits=1))
        end
    end

    # base plot
    p = plot(; size=(width, height), legend=false,
             xlims=(x1, x2), ylims=(-0.35, 0.35),
             axis=false, framestyle=:none, margin=5Plots.mm)

    # number line
    plot!(p, [x1, x2], [0.0, 0.0], lw=3, color=linecolor)

    # integer ticks (primary): medium length, black labels without decimals
    ticklenI = 0.04
    labelyI  = -0.12
    for (t, lbl) in zip(ticksI, labelsI)
        plot!(p, [t,t], [-ticklenI, ticklenI], lw=2, color=linecolor)
        annotate!(p, (t, labelyI, text(lbl, fontsize, labelcolor)))
    end

    # decimal ticks (secondary): shorter, gray, smaller labels
    if !isempty(ticksD)
        ticklenD = 0.025
        labelyD  = -0.12
        for (t, lbl) in zip(ticksD, labelsD)
            plot!(p, [t,t], [-ticklenD, ticklenD], lw=2, color=dec_color)
            annotate!(p, (t, labelyD, text(lbl, dec_fontsize, dec_color)))
        end
    end

    # optional arrow 0 → arrow_to
    if arrow_to !== nothing
        xstart = clamp(0.0, x1, x2)
        xend   = clamp(float(arrow_to), x1, x2)
        dx     = xend - xstart
        quiver!(p, [xstart], [0.0], quiver=([dx], [0.0]),
                lw=3, color=arrowcolor)
    end

    return p
end


"""
    plot_complexplane(xmin, xmax, ymin, ymax;
        allow_decimals::Bool = true,
        width::Int = 900, height::Int = 700,
        grid_color = :gray, grid_alpha = 0.5, grid_lw::Real = 1,
        axis_color = :black, axis_lw::Real = 2,
        show_axes::Bool = true, show_axis_labels::Bool = true,
        axis_label_fontsize::Int = 10,
        label_fontsize::Int = 10, label_color = :black,
        arrow_to::Union{Nothing, Real, Complex} = nothing,
        arrowcolor = :red, arrow_lw::Real = 3,
        # new: fine positioning
        real_axis_offset_frac::Float64 = 0.02,  # distance below y=0 for real labels (fraction of vertical span)
        imag_axis_offset_frac::Float64 = 0.015, # distance right of x=0 for imag labels (fraction of horizontal span)
        nudge_frac_x::Float64 = 0.006,          # tiny horizontal nudge to avoid vertical grid line overlap
        nudge_frac_y::Float64 = 0.006)          # tiny vertical nudge to avoid horizontal grid line overlap

Draw the complex plane over `[xmin, xmax] × [ymin, ymax]` with a thin gray grid
(no tick marks). Adds integer labels along the real axis
(..., -3,-2,-1,0,1,2,3, ...) and the imaginary axis
(..., -3i,-2i,-i, i,2i,3i, ...). Labels are positioned close to their axis and
nudged slightly so grid lines don’t pass through the text. Optionally draw a
vector 0 → `arrow_to` (real or complex).
"""
function plot_complexplane(xmin::Real, xmax::Real, ymin::Real, ymax::Real;
    allow_decimals::Bool = true,
    width::Int = 900, height::Int = 700,
    grid_color = :gray, grid_alpha = 0.5, grid_lw::Real = 1,
    axis_color = :black, axis_lw::Real = 2,
    show_axes::Bool = true, show_axis_labels::Bool = true,
    axis_label_fontsize::Int = 10,
    label_fontsize::Int = 10, label_color = :black,
    arrow_to::Union{Nothing, Real, Complex} = nothing,
    arrowcolor = :red, arrow_lw::Real = 3,
    real_axis_offset_frac::Float64 = 0.02,
    imag_axis_offset_frac::Float64 = 0.015,
    nudge_frac_x::Float64 = 0.006,
    nudge_frac_y::Float64 = 0.006)

    # Normalize limits
    x1, x2 = float(min(xmin, xmax)), float(max(xmin, xmax))
    y1, y2 = float(min(ymin, ymax)), float(max(ymin, ymax))
    (x2 ≤ x1 || y2 ≤ y1) && error("Invalid limits: ensure xmin < xmax and ymin < ymax")

    dx = x2 - x1
    dy = y2 - y1

    #  helper to count grid lines with given step
    count_lines(a,b,step) = max(Int(floor(b/step) - ceil(a/step) + 1), 0)

    function choose_grid_step(a,b; allow_decimals::Bool=true)
        L, R = ceil(Int, a), floor(Int, b)
        icount = max(R - L + 1, 0)
        if icount > 20
            for s in (2.0, 5.0, 10.0, 20.0, 50.0, 100.0, 200.0, 500.0, 1000.0)
                count_lines(a,b,s) ≤ 20 && return s
            end
            return 1000.0
        end
        if icount < 5 && allow_decimals
            for s in (0.5, 0.25, 0.1)
                c = count_lines(a,b,s)
                5 ≤ c ≤ 20 && return s
            end
            return 0.1
        end
        return 1.0
    end

    # Integer label step chooser (≤ 20 labels)
    function choose_int_step(a,b)
        L, R = ceil(Int, a), floor(Int, b)
        return (R < L) ? 1 :
               ((R - L + 1) ≤ 20 ? 1 :
                (findfirst(s -> (R ÷ s - cld(L,s) + 1) ≤ 20,
                           (2,5,10,20,50,100,200,500,1000)) |> x ->
                    x === nothing ? 1000 : (2,5,10,20,50,100,200,500,1000)[x]))
    end

    sx = choose_grid_step(x1, x2; allow_decimals)
    sy = choose_grid_step(y1, y2; allow_decimals)

    # Grid coordinates, skip 0 so axes can be drawn thicker
    function grid_vals(a,b,s)
        t0 = ceil(a/s)*s
        t1 = floor(b/s)*s
        t0 ≤ t1 ? [v for v in t0:s:t1 if !isapprox(v,0.0; atol=1e-10)] : Float64[]
    end
    vx = grid_vals(x1, x2, sx)  # vertical lines x = const
    hy = grid_vals(y1, y2, sy)  # horizontal lines y = const

    # base plot
    p = plot(; size=(width, height), legend=false,
             xlims=(x1, x2), ylims=(y1, y2),
             aspect_ratio=:equal, axis=false, framestyle=:none,
             margin=5Plots.mm)

    # Grid: thin gray lines
    for x in vx
        plot!(p, [x, x], [y1, y2], lw=grid_lw, color=grid_color, alpha=grid_alpha)
    end
    for y in hy
        plot!(p, [x1, x2], [y, y], lw=grid_lw, color=grid_color, alpha=grid_alpha)
    end

    # Axes (bold) if they cross the window
    has_y0 = (x1 ≤ 0.0 ≤ x2)
    has_x0 = (y1 ≤ 0.0 ≤ y2)
    if show_axes
        has_y0 && plot!(p, [0.0, 0.0], [y1, y2], lw=axis_lw, color=axis_color)
        has_x0 && plot!(p, [x1, x2], [0.0, 0.0], lw=axis_lw, color=axis_color)
        if show_axis_labels
            # "Re" near right end of real axis
            has_x0 && annotate!(p, (x2 - 0.02*dx, 0.02*dy,
                                    text("Re", axis_label_fontsize, axis_color, halign=:right)))
            # "Im" close to the imaginary axis, near the top
            has_y0 && annotate!(p, (0.0 - imag_axis_offset_frac*dx, y2 - 0.03*dy,
                                    text("Im", axis_label_fontsize, axis_color, halign=:right)))
        end
    end

    # Integer labels along axes (with small nudges to avoid grid overlap)
    # Real-axis labels: just below y=0, nudged slightly right
    if has_x0
        Lr, Rr = ceil(Int, x1), floor(Int, x2)
        if Rr ≥ Lr
            sr = choose_int_step(x1, x2)
            tstart = cld(Lr, sr) * sr
            tend   = (Rr ÷ sr) * sr
            y_label = clamp(-real_axis_offset_frac*dy, y1 + 0.04*dy, y2 - 0.04*dy)
            x_nudge = nudge_frac_x * dx
            for xr in tstart:sr:tend
                annotate!(p, (float(xr) + x_nudge, y_label,
                              text(string(xr), label_fontsize, label_color, halign=:center)))
            end
        end
    end

    # Imaginary axis labels: just to the right of x=0, nudged slightly up
    if has_y0
        Li, Ri = ceil(Int, y1), floor(Int, y2)
        if Ri ≥ Li
            si = choose_int_step(y1, y2)
            tstart = cld(Li, si) * si
            tend   = (Ri ÷ si) * si
            x_label = clamp(imag_axis_offset_frac*dx, x1 + 0.02*dx, x2 - 0.02*dx)
            y_nudge = nudge_frac_y * dy
            for yi in tstart:si:tend
                yi == 0 && continue
                lbl = yi == 1 ? "i" : yi == -1 ? "-i" : string(yi) * "i"
                annotate!(p, (x_label, float(yi) + y_nudge,
                              text(lbl, label_fontsize, label_color, halign=:left)))
            end
        end
    end

    # Optional arrow 0 → arrow_to (clipped to window)
    if arrow_to !== nothing && has_x0 && has_y0
        z = arrow_to isa Complex ? ComplexF64(arrow_to) : ComplexF64(arrow_to + 0im)
        xend, yend = clamp(real(z), x1, x2), clamp(imag(z), y1, y2)
        quiver!(p, [0.0], [0.0], quiver=([xend], [yend]),
                lw=arrow_lw, color=arrowcolor)
    end

    return p
end

"""
    plot_velocity(time, position, velocity, xmin, xmax;
        centerpos=2.5, voffset=0)
Draw a number line from `xmin` to `xmax` with an arrow at `position`
indicating the current position, and an arrow starting at `position`
indicating the velocity. The time `time` is shown at the top, the position
and velocity values are shown near their respective arrows.
"""
function plot_velocity(time,position,velocity,xmin,xmax;centerpos=2.5,voffset=0)
	tlabel = latexstring("t=$(round(time,digits=2))")
	pp = plot_numberline(xmin,xmax;arrow_to=position, show_decimals = true)
	plot!(pp, [position,position+velocity],[voffset,voffset],c=:blue,lw=3, arrow=true)
	scatter!(pp,[position],[voffset/2],c=:gray,msw=3)
	annotate!(pp,(position/centerpos,0.07,text(latexstring("Position=$(round(position,digits=2))"),14,:red,:left)))
	annotate!(pp,(position+velocity/2,-0.07,text(latexstring("Velocity=$(round(velocity,digits=2))"),14,:blue)))
	annotate!(pp,(0,0.2,text(tlabel,12,:black)))
	return pp
end

"""
    plot_velocity_complex(time, rate, width, height; drawpath=false)
Draw the complex plane over `[-width,width] × [-height,height]` with a thin gray grid.
Draw the position `s(t)=e^(rate*t)` as a gray dot, and the velocity
`v(t)=rate*e^(rate*t)` as a blue arrow starting at the position.
The time `time`, the position magnitude, and the angle are shown at the top.
If `drawpath` is true, also draw the path traced by the position from t=0 to t=`time`.
"""
function plot_velocity_complex(time,rate,width,height;drawpath=false)
	tl = 0:pi/100:2*pi
	tp = 0:pi/100:time
	position = exp(rate*time)
	velocity = rate*exp(rate*time)
	tlabel = latexstring("t=$(round(time,digits=2))")
	rlabel = latexstring("r=$(round(abs(position),digits=2))")
	alabel = latexstring("\\theta=$(round(time*imag(rate),digits=2))")
	size = 10^ceil(log10(abs(position)))
	xmax = max(width,size)
	ymax = max(height,height*size/width)
	pp = plot_complexplane(-xmax, xmax, -ymax, ymax; arrow_to=position,width=800,height=600)
	plot!(pp, [real(position),real(position+velocity)],[imag(position),imag(position+velocity)],c=:blue,lw=3, arrow=true)
	scatter!(pp,[real(position)],[imag(position)],c=:gray,msw=1)
	plot!(pp,cos.(tl),sin.(tl),ls=:dash,c=:green)
	if drawpath
		pt = exp.(rate*tp)
		plot!(pp,real(pt),imag(pt),ls=:dash,c=:black)
	end
	annotate!(pp,(xmax/3,0.9*ymax,text(tlabel,12,:black)))
	annotate!(pp,(xmax/3,0.8*ymax,text(rlabel,12,:black)))
	annotate!(pp,(xmax/3,0.7*ymax,text(alabel,12,:black)))
	if imag(rate) == 1
		expstr = "i"
	else
		expstr = "$(round(imag(rate),digits=2))i"
	end
	if real(rate) == 0
		annotate!(pp,(-0.9*xmax,-0.8*ymax,text(latexstring("s(t)=e^{",expstr,"t}"),15,:black,:left)))
		annotate!(pp,(-0.9*xmax,-0.9*ymax,text(latexstring("v(t)=",expstr,"e^{",expstr,"t}"),15,:black,:left)))
	else
		zstr = "($(round(real(rate),digits=2))+"*expstr*")"
		annotate!(pp,(-0.9*xmax,-0.8*ymax,text(latexstring("s(t)=e^{",zstr,"t}"),15,:black,:left)))
		annotate!(pp,(-0.9*xmax,-0.9*ymax,text(latexstring("v(t)=",zstr,"e^{",zstr,"t}"),15,:black,:left)))
	end
	return pp
end

"""
    plot_ntones(t, amp, ωs, ϕs, Amax; plot_trace=false)
Draw the phasor diagram (in the complex plane) for `nt` tones with amplitudes `amp`, frequencies `ωs`,
and phases `ϕs` at time `t`. The plot is limited to a square of size `Amax`.
If `plot_trace` is true, also draw the complex plane trace of the sum of the tones
over the interval [0, 4π].
Returns two plots: the phasor diagram and the time-domain trace of the imaginary part.
"""
function plot_ntones(t,amp,ωs,ϕs,Amax;plot_trace=false)
    tlabel = latexstring("t=$(round(t,digits=2))")
    xs = amp.*cos.(ωs*t .+ ϕs)
	ys = amp.*sin.(ωs*t .+ ϕs)
    nt = length(ωs)
    p1 = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(-Amax,Amax))
	plot!([0,0],[-Amax,Amax],ls=:dash,c=:gray,label="",xlabel="",ylabel=latexstring("Amplitude"))
	plot!(p1,[0,sum(xs)],[sum(ys),sum(ys)],ls=:dash,c=:blue,label="")
    xc = cumsum([0;xs])
    yc = cumsum([0;ys])
    for n=1:nt
        plot!(p1,[xc[n],xc[n+1]],[yc[n],yc[n+1]],c=:red,label="")
        plot!(p1,[xc[n].+amp[n]*cos.(0:pi/15:2*pi)],[yc[n].+amp[n]*sin.(0:pi/15:2*pi)],c=:green,label="")
        scatter!(p1,[xc[n]],[yc[n]],c=:red,ms=4,alpha=0.6,label="")
    end
	plot!(p1,[0,0],[0,yc[end]],c=:blue,label="")
	plot!(p1,[0,Amax],[yc[end],yc[end]],ls=:dash,c=:blue,label="")
	scatter!(p1,[xc[end]],[yc[end]],c=:red,ms=5,label="")
	scatter!(p1,[0],[yc[end]],c=:blue,ms=5,label="")
	tb = (0:pi/40:4*pi)
    p2 = plot([0,4*pi],[0,0],ls=:dash,c=:black,label="",ylims=(-Amax,Amax))
	plot!(p2,tb,sum(amp'.*sin.(tb*ωs' .+ ϕs'),dims=2),label="",c=:blue,ylims=(-Amax,Amax))
	scatter!(p2,[t],[sum(ys)],c=:blue,ms=5,label="",xlims=(0,4*pi))
	plot!(p2,[0,t],[sum(ys),sum(ys)],c=:blue,ls=:dash,label="")
    annotate!(p2,(0.7*Amax,0.9*Amax,text(tlabel,12,:black,:left)))
    return p1, p2
end

"""
    plot_ntones_twoaxis(t, amp, ωs, ϕs, Amax; plot_trace=false)
The same as `plot_ntones` but also returns an additional plot showing the time-domain trace of the real part.
"""
function plot_ntones_twoaxis(t,amp,ωs,ϕs,Amax;plot_trace=false)
    tlabel = latexstring("t=$(round(t,digits=2))")
    xs = amp.*cos.(ωs*t .+ ϕs)
	ys = amp.*sin.(ωs*t .+ ϕs)
    nt = length(ωs)
    p1 = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(-Amax,Amax))
	plot!([0,0],[-Amax,Amax],ls=:dash,c=:gray,label="",xlabel="",ylabel=latexstring("Amplitude"))
	plot!(p1,[0,sum(xs)],[sum(ys),sum(ys)],ls=:dash,c=:blue,label="")
    xc = cumsum([0;xs])
    yc = cumsum([0;ys])
    for n=1:nt
        plot!(p1,[xc[n],xc[n+1]],[yc[n],yc[n+1]],c=:red,label="")
        plot!(p1,[xc[n].+amp[n]*cos.(0:pi/15:2*pi)],[yc[n].+amp[n]*sin.(0:pi/15:2*pi)],c=:green,label="")
        scatter!(p1,[xc[n]],[yc[n]],c=:red,ms=4,alpha=0.6,label="")
    end
	plot!(p1,[0,0],[0,yc[end]],c=:blue,label="")
	plot!(p1,[0,Amax],[yc[end],yc[end]],ls=:dash,c=:blue,label="")
	plot!(p1,[xc[end],xc[end]],[yc[end],-Amax],ls=:dash,c=:red,label="")
	scatter!(p1,[xc[end]],[yc[end]],c=:red,ms=5,label="")
	scatter!(p1,[0],[yc[end]],c=:blue,ms=5,label="")
	tb = (0:pi/40:4*pi)
    p2 = plot([0,4*pi],[0,0],ls=:dash,c=:black,label="",ylims=(-Amax,Amax))
	plot!(p2,tb,sum(amp'.*sin.(tb*ωs' .+ ϕs'),dims=2),label="",c=:blue,ylims=(-Amax,Amax))
	scatter!(p2,[t],[sum(ys)],c=:blue,ms=5,label="",xlims=(0,4*pi))
	plot!(p2,[0,t],[sum(ys),sum(ys)],c=:blue,ls=:dash,label="")
    annotate!(p2,(0.7*Amax,0.9*Amax,text(tlabel,12,:black,:left)))
	p3 = plot([0,0],[0,4*pi],ls=:dash,c=:black,label="",xlims=(-Amax,Amax))
	plot!(p3,sum(amp'.*cos.(tb*ωs' .+ ϕs'),dims=2),tb,label="",c=:red,xlims=(-Amax,Amax))
	scatter!(p3,[sum(xs)],[t],c=:red,ms=5,label="",ylims=(0,4*pi))
	plot!(p3,[sum(xs),sum(xs)],[0,t],c=:red,ls=:dash,label="",yflip = true)
    return p1, p2, p3
end

"""
    plot_ntones_vertical(t, amp, ωs, ϕs, Amax)
The same as `plot_ntones` but with a vertical layout displaying the phasor diagram
and time-domain trace for each tone separately.
"""
function plot_ntones_vertical(t,amp,ωs,ϕs,Amax)
    tlabel = latexstring("t=$(round(t,digits=2))")
    xs = amp.*cos.(ωs*t .+ ϕs)
	ys = amp.*sin.(ωs*t .+ ϕs)
    nt = length(ωs)
    offsetmax = -2-2.1*nt
    p1 = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(offsetmax,Amax))
	plot!([0,0],[offsetmax,Amax],ls=:dash,c=:gray,label="",xlabel="",ylabel=latexstring("Amplitude"))
	plot!([0,sum(xs)],[sum(ys),sum(ys)],ls=:dash,c=:blue,label="")
    xc = cumsum([0;xs])
    yc = cumsum([0;ys])
    for n=1:nt
        plot!(p1,[xc[n],xc[n+1]],[yc[n],yc[n+1]],c=:red,label="")
        plot!(p1,[xc[n].+amp[n]*cos.(0:pi/15:2*pi)],[yc[n].+amp[n]*sin.(0:pi/15:2*pi)],c=:green,label="")
        scatter!(p1,[xc[n]],[yc[n]],c=:red,ms=4,alpha=0.6,label="")
    end
    plot!(p1,[0,0],[0,yc[end]],c=:blue,label="")
    plot!(p1,[0,Amax],[yc[end],yc[end]],ls=:dash,c=:blue,label="")
    scatter!(p1,[xc[end]],[yc[end]],c=:red,ms=5,label="")
    scatter!(p1,[0],[yc[end]],c=:blue,ms=5,label="")
    tb = (0:pi/40:4*pi)
	for n=1:nt
		offset = -1-2*n
		plot!(p1,[-Amax,Amax],[offset,offset],ls=:dash,c=:gray,label="")
		plot!(p1,amp[n]*cos.(0:pi/20:2*pi),amp[n]*sin.(0:pi/20:2*pi).+offset,c=:green,label="")
		plot!(p1,[0,xs[n]],[0,ys[n]].+offset,c=:red,label="")
		scatter!(p1,[xs[n]],[ys[n]].+offset,c=:red,ms=4,label="")
		plot!(p1,[0,0],[0,ys[n]].+offset,c=:green,label="")
		scatter!(p1,[0],[ys[n]+offset],c=:green,ms=5,label="")
		plot!(p1,[0,Amax],[ys[n],ys[n]].+offset,ls=:dash,c=:green,label="")
		plot!(p1,[0,xs[n]],[ys[n],ys[n]].+offset,ls=:dash,c=:green,label="")
	end
    yb = amp'.*sin.(tb*ωs' .+ ϕs')
	p2 = plot(tb,sum(yb,dims=2),label="",c=:blue,xlims=(0,4*pi),ylims=(offsetmax,Amax))
	for n=0:nt
		if n>0
			offset = -1-2*n
            plot!(p2,tb,yb[:,n].+offset,label="",c=:green)
			plot!(p2,[t,t],[0,ys[n]].+offset,c=:green,label="")
			plot!(p2,[0,4*pi],[0,0].+offset,ls=:dash,c=:black,label="")
			plot!(p2,[0,t],[ys[n],ys[n]].+offset,c=:green,ls=:dash,label="")
            scatter!(p2,[t],[ys[n]+offset],c=:green,ms=5,label="")
		else
			plot!(p2,[0,4*pi],[0,0],ls=:dash,c=:black,label="")
			plot!(p2,[t,t],[0,sum(ys)],c=:blue,label="")
			plot!(p2,[0,t],[sum(ys),sum(ys)],c=:blue,ls=:dash,label="")
            scatter!(p2,[t],[sum(ys)],c=:blue,ms=5,label="")
		end
	end
    annotate!(p2,(0.7*4*pi,0.9*Amax,text(tlabel,12,:black,:left)))
    return p1, p2
end

"""
    plot_fasors(t, amp, ωs, ϕs, Amax)
Draw the phasor diagram (in the complex plane) for `nt` tones with amplitudes `amp`, frequencies `ωs`,
and phases `ϕs` at time `t`. The plot is limited to a square of side length `Amax`.
"""
function plot_fasors(t, amp, ωs, ϕs, Amax)
    xs = amp.*cos.(ωs*t .+ ϕs)
	ys = amp.*sin.(ωs*t .+ ϕs)
	pps = []
    nt = length(ωs)
	for n=1:nt
		pp = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(-Amax,Amax))
		plot!([0,0],[-Amax,Amax],ls=:dash,c=:gray,axis=false,label="")
		plot!([0,xs[n]],[0,ys[n]],c=:red,label="")
		plot!(amp[n]*cos.(0:pi/20:2*pi),amp[n]*sin.(0:pi/20:2*pi),c=:green,label="")
		scatter!([xs[n]],[ys[n]],c=:red,ms=4,alpha=0.6,label="")
		annotate!(0.85*Amax,0.9*Amax,text(latexstring("$(Int(round(ωs[n])))"),12,:black,:right))
		push!(pps,pp)
	end
    return pps
end

function plot_fasor_product(t, a1, a2, ω1, ω2, ϕ1, ϕ2, Amax)
    s1 = a1*exp(im*(ω1*t + ϕ1))
    s2 = a2*exp(-im*(ω2*t + ϕ2))
    s = s1*s2
    xs = [real(s1), real(s2), real(s)]
    ys = [imag(s1), imag(s2), imag(s)]
	p1 = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(-Amax,Amax))
	plot!([0,0],[-Amax,Amax],ls=:dash,c=:gray,axis=false,label="")
	plot!([0,xs[1]],[0,ys[1]],c=:red,label="")
    plot!(a1*cos.(0:pi/20:2*pi),a1*sin.(0:pi/20:2*pi),c=:green,label="")
	scatter!([xs[1]],[ys[1]],c=:red,ms=4,alpha=0.6,label="")
	annotate!(0.85*Amax,0.9*Amax,text(latexstring("$(Int(round(ω1)))"),12,:black,:right))
    p2 = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(-Amax,Amax))
	plot!([0,0],[-Amax,Amax],ls=:dash,c=:gray,axis=false,label="")
	plot!([0,xs[2]],[0,ys[2]],c=:red,label="")
    plot!(a2*cos.(0:pi/20:2*pi),a2*sin.(0:pi/20:2*pi),c=:green,label="")
	scatter!([xs[2]],[ys[2]],c=:red,ms=4,alpha=0.6,label="")
	annotate!(0.85*Amax,0.9*Amax,text(latexstring("$(Int(round(ω2)))"),12,:black,:right))
    p3 = plot([-Amax,Amax],[0,0],ls=:dash,c=:gray,label="",xlims=(-Amax,Amax),ylims=(-Amax,Amax))
	plot!([0,0],[-Amax,Amax],ls=:dash,c=:gray,axis=false,label="")
	plot!([0,xs[3]],[0,ys[3]],c=:red,label="")
    plot!(a1*a2*cos.(0:pi/20:2*pi),a1*a2*sin.(0:pi/20:2*pi),c=:green,label="")
	scatter!([xs[3]],[ys[3]],c=:red,ms=4,alpha=0.6,label="")
	annotate!(0.85*Amax,0.9*Amax,text(latexstring("$(Int(round(ω1-ω2)))"),12,:black,:right))
    return p1, p2, p3
end

function taylor_plot5(f::Num, x::Num, a::Real,N::Int64,x1::Real,x2::Real,ylimit::Bool)
	dx = Differential(x);
    dfdx = expand_derivatives(dx(f))
	dfdx2 = expand_derivatives(dx(dfdx))
	dfdx3 = expand_derivatives(dx(dfdx2))
	dfdx4 = expand_derivatives(dx(dfdx3))
	dfdx5 = expand_derivatives(dx(dfdx4))
    f0 = substitute(f,Dict(x=>a))
	dfdx0 = substitute(dfdx,Dict(x=>a))
	dfdx20 = substitute(dfdx2,Dict(x=>a))
	dfdx30 = substitute(dfdx3,Dict(x=>a))
	dfdx40 = substitute(dfdx4,Dict(x=>a))
	dfdx50 = substitute(dfdx5,Dict(x=>a))
    flist = [f0,simplify(dfdx0),simplify(dfdx20),simplify(dfdx30),simplify(dfdx40),simplify(dfdx50)]
	xlist = ["","(x-a)","\\frac{(x-a)^2}{2!}","\\frac{(x-a)^3}{3!}","\\frac{(x-a)^4}{4!}","\\frac{(x-a)^5}{5!}"]
	lstring = ""	
	ftaylor = 0
	for n = 1:N+1
		s1 = latexify(flist[n],env=:raw)
		if (n>1) && !(s1[1]== '-')
			lstring *= "+"
		end	
		lstring *= s1
		lstring *= xlist[n]
		ftaylor += flist[n]*(x-a)^(n-1)/factorial(n-1)
	end
	lstring *= "+..."
    fP = Symbolics.value(substitute(f, Dict(x=>a)))
	farr = [Symbolics.value(substitute(f, Dict(x=>y))) for y in x1:0.01:x2]
	maxf = maximum(farr[.!isnan.(farr)])
	minf= minimum(farr[.!isnan.(farr)])
	margin = 0.1*(maxf-minf)
	ftaylor_subs = substitute(ftaylor,Dict(a=>a))
	taylor_plot = plot(f,label=latexify(f,env=:inline))
	plot!(ftaylor_subs,label=latexstring(lstring))
	scatter!([par.a],[fP],ms=4,c=:black,label="")
	xlims!(x1,x2)
	plot!([x1,x2],[0,0],ls=:dash,c=:black,label="")
	if ylimit
		ylims!(x1,x2)
		plot!([0,0],[x1,x2],ls=:dash,c=:black,label="")
	else	
		ylims!(minf-margin,maxf+margin)
		plot!([0,0],[minf-margin,maxf+margin],ls=:dash,c=:black,label="")
	end	
	plot!(background_color_legend = RGBA(0,0,0,0.1))
	plot!(foreground_color_legend = RGBA(0,0,0,0.3))
    return taylor_plot, lstring
end