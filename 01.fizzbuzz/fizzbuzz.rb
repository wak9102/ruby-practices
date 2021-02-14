#! /usr/bin/env ruby

int = 1
while int <= 100 do
	if int % (3 * 5) == 0
		puts "FizzBuzz"
	elsif int % 3 == 0
		puts "Fizz"
	elsif int % 5 == 0
		puts "Buzz"
	else
		puts int
	end
	int += 1
end

