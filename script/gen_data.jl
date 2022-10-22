using Consensus
using QuantumStateBase
using ProgressMeter
using JLD2

function gen_data!(ps_view, ws_view, r, θ, θs, xs, 𝐰)
    ps_view .= pdf_with_grid(r, θ, θs, xs)

    ws_view .= Consensus.wigner(
        SqueezedState(r, θ, Matrix, dim=size(𝐰, 1)),
        𝐰=𝐰
    )

    return ps_view, ws_view
end

function gen_data(n; θs=LinRange(0, 2π, 101), xs=LinRange(0, 5, 101), dim=100)
    @time begin
        θx_grid = gen_grid(θs, xs)
        𝐰 = calc_𝐰(θx_grid, dim=dim)
    end

    ps = Array{Float64}(undef, 3, size(𝐰)[3:4]..., n)
    ws = Array{Float64}(undef, 1, size(𝐰)[3:4]..., n)

    prog = Progress(n)
    for i in 1:n
        r = rand()
        θ = 2π * rand()

        gen_data!(view(ps, :, :, :, i) , view(ws, 1, :, :, i), r, θ, θs, xs, 𝐰)

        ProgressMeter.next!(prog)
    end

    return ps, ws
end

function main()
    ps, ws = gen_data(100)

    jldsave(joinpath(@__DIR__, "..", "data", "p2w.jld2"); ps, ws)
end

main()
