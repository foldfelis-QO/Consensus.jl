using QuantumStateBase
using QuantumStateDistributions
using Tullio

export
    gen_grid,
    pdf_with_grid,
    calc_𝐰,
    wigner

const DIM = 100

function gen_grid(θs::AbstractRange{T}, xs::AbstractRange{T}) where {T<:Real}
    m, n = length(θs), length(xs)
    grid = Array{T}(undef, 2, m, n)

    grid[1, :, :] .= reshape(repeat(θs, n), m, n)
    grid[2, :, :] .= reshape(repeat(xs, m), n, m)'

    return grid
end

function pdf_with_grid(r, θ, θs, xs; dim=DIM)
    probabilities = qpdf(GaussianStateBHD(SqueezedState(r, θ, Matrix, dim=dim)), θs, xs)
    grid = gen_grid(θs, xs)

    return vcat(grid, reshape(probabilities, 1, size(probabilities)...))
end

function calc_𝐰(θx_grid; dim=DIM)
    xp_grid = polar2cartesian(θx_grid)
    𝐰 = Array{ComplexF64}(undef, dim, dim, size(xp_grid)[2:3]...)

    return calc_𝐰!(𝐰, xp_grid, dim=dim)
end

function calc_𝐰!(𝐰, xp_grid; dim)
    dims = Base.OneTo(dim)
    xs, ps = xp_grid[1, :, :], xp_grid[2, :, :]
    @tullio 𝐰[m, n, i, j] = QuantumStateBase.gaussian_function(xs[i, j], ps[i, j]) .*
        QuantumStateBase.coefficient_of_wave_function(dims[m], dims[n]) .*
        QuantumStateBase.z_to_power(dims[m], dims[n], xs[i, j], ps[i, j]) .*
        QuantumStateBase.laguerre(dims[m], dims[n], xs[i, j], ps[i, j])

    return 𝐰
end

function wigner(ρ; 𝐰)
    x_size, p_size = size(𝐰)[3:4]

    𝐰_surface = Matrix{Float64}(undef, x_size, p_size)
    Threads.@threads for i in 1:x_size
        Threads.@threads for j in 1:p_size
            𝐰_surface[i, j] = real(sum(ρ .* 𝐰[:, :, i, j]))
        end
    end

    return 𝐰_surface
end
