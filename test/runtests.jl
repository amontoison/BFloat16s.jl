using Test, BFloat16s, Printf

@testset "comparisons" begin
	@test BFloat16(1)   <  BFloat16(2)
	@test BFloat16(1f0) <  BFloat16(2f0)
	@test BFloat16(1.0) <  BFloat16(2.0)
	@test BFloat16(1)   <= BFloat16(2)
	@test BFloat16(1f0) <= BFloat16(2f0)
	@test BFloat16(1.0) <= BFloat16(2.0)
	@test BFloat16(2)   >  BFloat16(1)
	@test BFloat16(2f0) >  BFloat16(1f0)
	@test BFloat16(2.0) >  BFloat16(1.0)
	@test BFloat16(2)   >= BFloat16(1)
	@test BFloat16(2f0) >= BFloat16(1f0)
	@test BFloat16(2.0) >= BFloat16(1.0)
	@test BFloat16(2)   != BFloat16(1)
	@test BFloat16(2f0) != BFloat16(1f0)
	@test BFloat16(2.0) != BFloat16(1.0)
end

@testset "conversions" begin
	@test Float32(BFloat16(10)) == 1f1
	@test Float64(BFloat16(10)) == 10.0
	@test Int32(BFloat16(10)) == Int32(10)
	@test Int64(BFloat16(10)) == Int64(10)
end

@testset "functions" begin
	@test abs(BFloat16(-10)) == BFloat16(10)
	@test BFloat16(2) ^ BFloat16(4) == BFloat16(16)
	@test eps(BFloat16) == BFloat16(0.0078125)
	@test sqrt(BFloat16(4f0)) == BFloat16(2f0)
	@test round(BFloat16(10.4), RoundUp) == BFloat16(11.0)
	@test round(BFloat16(10.6), RoundDown) == BFloat16(10.0)
	@test round(BFloat16(3.2), RoundNearest) == BFloat16(3.0)
	@test round(BFloat16(4.8), RoundNearest) == BFloat16(5.0)
end

@testset "printf" begin
  for (fmt, val) in (("%7.2f", "   1.23"),
                     ("%-7.2f", "1.23   "),
                     ("%07.2f", "0001.23"),
                     ("%.0f", "1"),
                     ("%#.0f", "1."),
                     ("%.3e", "1.234e+00"),
                     ("%.3E", "1.234E+00"),
                     ("%.2a", "0x1.3cp+0"),
                     ("%.2A", "0X1.3CP+0")),
      num in (BFloat16(1.234),)
      @test @eval(@sprintf($fmt, $num) == $val)
  end
  @test (@sprintf "%f" BFloat16(Inf)) == "Inf"
  @test (@sprintf "%f" BFloat16(NaN)) == "NaN"
  @test (@sprintf "%.0e" BFloat16(3e2)) == "3e+02"
  @test (@sprintf "%#.0e" BFloat16(3e2)) == "3.e+02"

  for (fmt, val) in (("%10.5g", "     123.5"),
                     ("%+10.5g", "    +123.5"),
                     ("% 10.5g","     123.5"),
                     ("%#10.5g", "    123.50"),
                     ("%-10.5g", "123.5     "),
                     ("%-+10.5g", "+123.5    "),
                     ("%010.5g", "00000123.5")),
      num in (BFloat16(123.5),)
      @test @eval(@sprintf($fmt, $num) == $val)
  end
  @test( @sprintf( "%10.5g", BFloat16(-123.5) ) == "    -123.5")
  @test( @sprintf( "%010.5g", BFloat16(-123.5) ) == "-0000123.5")
  @test (@sprintf "%a" BFloat16(1.5)) == "0x1.8p+0"
end
