using Plots

export
    cartesian2polar,
    polar2cartesian,
    plot_wigner_in_polar

# cartesian to polar

function cartesian2polar(ps::M) where {M<:AbstractMatrix{<:Real}}
    out = M(undef, size(ps))

    return cartesian2polar!(ps, out)
end

function cartesian2polar!(ps::M, out::M) where {M<:AbstractMatrix{<:Real}}
    out[1, :] .= sqrt.(ps[1, :].^2 + ps[2, :].^2)
    out[2, :] .= angle.(ps[1, :] + im*ps[2, :])

    return out
end

function cartesian2polar(p::V) where {V<:AbstractVector{<:Real}}
    return cartesian2polar(reshape(p, 2, 1))
end

function cartesian2polar(ps::A) where {A<:AbstractArray{<:Real}}
    return reshape(cartesian2polar(reshape(ps, 2, :)), size(ps))
end

# polar to cartesian

function polar2cartesian(ps::M) where {M<:AbstractMatrix{<:Real}}
    out = M(undef, size(ps))

    return polar2cartesian!(ps, out)
end

function polar2cartesian!(ps::M, out::M) where {M<:AbstractMatrix{<:Real}}
    out[1, :] .= ps[2, :] .* cos.(ps[1, :])
    out[2, :] .= ps[2, :] .* sin.(ps[1, :])

    return out
end

function polar2cartesian(p::V) where {V<:AbstractVector{<:Real}}
    return polar2cartesian(reshape(p, 2, 1))
end

function polar2cartesian(ps::A) where {A<:AbstractArray{<:Real}}
    return reshape(polar2cartesian(reshape(ps, 2, :)), size(ps))
end

# plot

function plot_wigner_in_polar(θs::AbstractRange, xs::AbstractRange, w::AbstractMatrix; kwargv...)
    lim = maximum(abs.(w))

    default_kwargv = Dict([
        :title => "Wigner Function",
        :clim => (-lim, lim),
        :color => :coolwarm,
        :proj => :polar,
        :aspect_ratio => :equal,
        :axis => false,
    ])

    return heatmap(θs, xs, w'; merge(default_kwargv, kwargv)...)
end
