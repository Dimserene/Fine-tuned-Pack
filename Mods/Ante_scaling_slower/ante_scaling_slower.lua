--- STEAMODDED HEADER
--- MOD_NAME: Ante scaling linear
--- MOD_ID: Infarctus_Ante_scaling_linear
--- MOD_AUTHOR: [infarctus, Dimserene]
--- MOD_DESCRIPTION: Slows the ante scaling to 2x each ante.
----------------------------------------------
------------MOD CODE -------------------------

local scaling_factor = 2
function get_blind_amount(ante)
    local k = to_big(0.75)
    if not G.GAME.modifiers.scaling or G.GAME.modifiers.scaling == 1 then 
      local amounts = {
        to_big(300),  to_big(800), to_big(2000),  to_big(5000),  to_big(11000),  to_big(20000),   to_big(35000),  to_big(50000)
      }
      if ante < 1 then return to_big(100) end
      if ante <= 8 then return amounts[ante] end
      local amount = math.floor(amounts[8]*scaling_factor^(ante-8))
	  if type(amount) == 'table' then
          if (amount:lt(R.MAX_SAFE_INTEGER)) then
            local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
            amount = math.floor(amount / exponent):to_number() * exponent
          end
          amount:normalize()
      else
        amount = amount - amount%(10^math.floor(math.log10(amount)-1))
      end
	  return amount
	  
	  
    elseif G.GAME.modifiers.scaling == 2 then 
      local amounts = {
        to_big(300),  to_big(900), to_big(2600),  to_big(8000),  to_big(20000),  to_big(36000),  to_big(60000),  to_big(100000)
        --300,  900, 2400,  7000,  18000,  32000,  56000,  90000
      }
      if ante < 1 then return to_big(100) end
      if ante <= 8 then return amounts[ante] end
      local amount = math.floor(amounts[8]*scaling_factor^(ante-8))
	  if type(amount) == 'table' then
          if (amount:lt(R.MAX_SAFE_INTEGER)) then
            local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
            amount = math.floor(amount / exponent):to_number() * exponent
          end
          amount:normalize()
      else
        amount = amount - amount%(10^math.floor(math.log10(amount)-1))
      end
	  return amount
	  
	  
    elseif G.GAME.modifiers.scaling == 3 then 
      local amounts = {
        to_big(300),  to_big(1000), to_big(3200),  to_big(9000),  to_big(25000),  to_big(60000),  to_big(110000),  to_big(200000)
        --300,  1000, 3000,  8000,  22000,  50000,  90000,  180000
      }
      if ante < 1 then return to_big(100) end
      if ante <= 8 then return amounts[ante] end
      local amount = math.floor(amounts[8]*scaling_factor^(ante-8))
	  if type(amount) == 'table' then
          if (amount:lt(R.MAX_SAFE_INTEGER)) then
            local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
            amount = math.floor(amount / exponent):to_number() * exponent
          end
          amount:normalize()
      else
        amount = amount - amount%(10^math.floor(math.log10(amount)-1))
      end
	  return amount
	  
	  
	elseif G.GAME.modifiers.scaling == 4 then 
      local amounts = {
        to_big(300),  to_big(1100), to_big(3800),  to_big(10000),  to_big(30000),  to_big(100000),  to_big(180000),  to_big(300000)
      }
      if ante < 1 then return to_big(100) end
      if ante <= 8 then return amounts[ante] end
      local amount = math.floor(amounts[8]*scaling_factor^(ante-8))
	  if type(amount) == 'table' then
          if (amount:lt(R.MAX_SAFE_INTEGER)) then
            local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
            amount = math.floor(amount / exponent):to_number() * exponent
          end
          amount:normalize()
      else
        amount = amount - amount%(10^math.floor(math.log10(amount)-1))
      end
	  return amount
	  
	  
	elseif G.GAME.modifiers.scaling == 5 then 
      local amounts = {
        to_big(300),  to_big(1500), to_big(5000),  to_big(13000),  to_big(35000),  to_big(150000),  to_big(260000),  to_big(400000)
      }
      if ante < 1 then return to_big(100) end
      if ante <= 8 then return amounts[ante] end
      local amount = math.floor(amounts[8]*scaling_factor^(ante-8))
	  if type(amount) == 'table' then
          if (amount:lt(R.MAX_SAFE_INTEGER)) then
            local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
            amount = math.floor(amount / exponent):to_number() * exponent
          end
          amount:normalize()
      else
        amount = amount - amount%(10^math.floor(math.log10(amount)-1))
      end
	  return amount
	  
	  
    end
end
----------------------------------------------
------------MOD CODE END----------------------
