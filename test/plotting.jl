@testset "ZonedDateTime plot recipe" begin
    # Note: in these tests we use `RecipesBase.apply_recipe` rather than `plot` as it
    # lets use avoid a Plots.jl dependency and issues with running that during tests.
    # `RecipesBase.apply_recipe` is not a documented API, but is fairly usable.
    # Comments above each use show the matching `plot` function command
    start_zdt = ZonedDateTime(2017,1,1,0,0,0, tz"EST")
    end_zdt = ZonedDateTime(2017,1,1,10,30,0, tz"EST")
    zoned_dates = start_zdt:Hour(1):end_zdt

    # what the point should be after recipe is applied
    expected_dates = DateTime.(zoned_dates, Local)

    @testset "No label" begin
        # The below use of `apply_recipe` is equivelent to:
        # plot(zoned_dates, 1:11)
        result, = RecipesBase.apply_recipe(Dict{Symbol, Any}(), zoned_dates, 1:11)
        xs, ys = result.args
        @test xs == expected_dates
        @test ys == 1:11
        @test result.plotattributes[:xguide] == "(timezone: EST)"
    end

    @testset "label (should append to it)" begin
        # The below use of `apply_recipe` is equivelent to:
        # plot(zoned_dates, 1:11; xguide="X-Axis")
        result, = RecipesBase.apply_recipe(Dict{Symbol, Any}(:xguide=>"Hi"), zoned_dates, 1:11)
        xs, ys = result.args
        @test xs == expected_dates
        @test ys == 1:11
        @test result.plotattributes[:xguide] == "Hi (timezone: EST)"
    end

    @testset "No items" begin
        empty_xs = ZonedDateTime[]
        empty_ys = 0:-1
        result = RecipesBase.apply_recipe(Dict{Symbol, Any}(:xguide=>"Hi"), empty_xs, empty_ys)
        @test true  # we are just making sure it it didn't error
    end
end
