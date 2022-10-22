### A Pluto.jl notebook ###
# v0.19.14

using Markdown
using InteractiveUtils

# ╔═╡ c7df4c50-51df-11ed-3796-7de98c6dd1d0
using Pkg; Pkg.develop(path=".."); Pkg.activate("..")

# ╔═╡ 01c1c91e-27d2-4050-aec4-7eab01b5b381
begin
	using Consensus
	using QuantumStateBase
	using Plots
end

# ╔═╡ bfe8ef79-a3f4-4a3a-a38e-010b9b26bddb
begin
	s = 101

	r = 0.8
	θ = π/2

	θs = LinRange(0, 2π, s)
	xs = LinRange(0, 3, s)
end;

# ╔═╡ ce19a751-d0e5-4109-96d5-78e58ef3f1d7
ps = pdf_with_grid(r, θ, θs, xs);

# ╔═╡ b4621a97-4768-48fa-b500-e134ed731739
surface(
	ps[1, :, :], ps[2, :, :], ps[3, :, :],
	color=:coolwarm,
	clim=(-maximum(abs.(ps[3, :, :])), maximum(abs.(ps[3, :, :]))),
	zlim=(-maximum(abs.(ps[3, :, :])), maximum(abs.(ps[3, :, :]))),
	camera=(0, 90)
)

# ╔═╡ 9b43ee56-bdb5-44e2-b502-b99e367fa3cf
w = calc_𝐰(ps[1:2, :, :]);

# ╔═╡ f7c1061d-aa2f-47c7-a00f-544c63e9cc1d
ws = Consensus.wigner(
	SqueezedState(r, θ, Matrix, dim=size(w, 1)),
	𝐰=w
);

# ╔═╡ 918a8576-b58e-4db2-b477-fbde55212917
begin
	plot_wigner_in_polar(θs, xs, ws)
	plot!([0, 0], [-3, 3], color=:black, legend=false)
	plot!([π/2, π/2], [-3, 3], color=:black, legend=false)
	annotate!(0.9, 0, text("→ x"))
	annotate!(0, 0.9, text("p\n↑"))
end

# ╔═╡ caf92a38-a8cf-4e8f-b3d9-822c6cae0052


# ╔═╡ Cell order:
# ╠═c7df4c50-51df-11ed-3796-7de98c6dd1d0
# ╠═01c1c91e-27d2-4050-aec4-7eab01b5b381
# ╠═bfe8ef79-a3f4-4a3a-a38e-010b9b26bddb
# ╠═ce19a751-d0e5-4109-96d5-78e58ef3f1d7
# ╠═b4621a97-4768-48fa-b500-e134ed731739
# ╠═9b43ee56-bdb5-44e2-b502-b99e367fa3cf
# ╠═f7c1061d-aa2f-47c7-a00f-544c63e9cc1d
# ╠═918a8576-b58e-4db2-b477-fbde55212917
# ╠═caf92a38-a8cf-4e8f-b3d9-822c6cae0052
