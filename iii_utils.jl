using Plots, LaTeXStrings
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

    # --- helpers ---
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

    # --- base plot ---
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

    # --- Integer labels along axes (with small nudges to avoid grid overlap) ---
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

    # Imag-axis labels: just to the right of x=0, nudged slightly up
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

function plot_velocity(time,position,velocity,xmin,xmax;centerpos=2.5,voffset=0)
	tlabel = latexstring("t=$(round(time,digits=2))")
	pp = plot_numberline(xmin,xmax;arrow_to=position, show_decimals = true)
	plot!(pp, [position,position+velocity],[voffset,voffset],c=:blue,lw=3, arrow=true)
	scatter!(pp,[position],[voffset/2],c=:gray,msw=3)
	annotate!(pp,(position/centerpos,0.07,text(latexstring("Position=$(round(position,digits=2))"),14,:red,:left)))
	annotate!(pp,(position+velocity/2,-0.07,text(latexstring("Velocity=$(round(velocity,digits=2))"),14,:blue)))
	annotate!(pp,(0,0.2,text(tlabel,12,:black)))
	return pp
end;