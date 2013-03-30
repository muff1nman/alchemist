# Alchemist

[![Build Status](https://travis-ci.org/halogenandtoast/alchemist.png?branch=master)](https://travis-ci.org/halogenandtoast/alchemist)
[![Code Climate](https://codeclimate.com/github/halogenandtoast/alchemist.png)](https://codeclimate.com/github/halogenandtoast/alchemist)

A ruby library for scientific conversions

## Usage

Alchemist provides three methods for managing conversions - `register`, `load`, and `unit`. These three methods form the base of Alchemist's functionality. Alchemist also provides some optional syntactical sugar you can mix in.

### Alchemist.register

`Alchemist.register` creates a category for measurements.

```ruby
Alchemist.register(:distance)
```

You can pass this method a block in order to define measurements within that category. Measurements should be described in terms of `Float`.

```ruby
Alchemist.register(:distance) do |category|
  category.define :meter, 1.0
  category.define :foot, 0.3048
end
```

For defining measurements you'll need to define units in terms of a base value. The base value is always 1.0. You may choose any unit to be this base value, but all other units must be expressed in terms of it. For instance 1 foot is 0.3048 meters.

When defining a measurement, you may provide additional details such as a plural name, short name, and aliases for the unit.

```ruby
Alchemist.register(:distance) do |category|
  category.define(:meter, 1.0) do |measurement|
    measurement.plural :meters
    measurement.short :meter
    measurement.alias :metre, :metres # the second value will be the plural form for the alias.
    # If you do not provide a second value the singular form will be used
  end
end
```

When you do not define plural or short, the base name will be used.

If you have a unit which can not be converted from a base value and instead requires a formula, exclude the second argument in the define and provide `from` and `to` with blocks for conversion

```ruby
Alchemist.register(:temperature) do |category|
  category.define(:kelvin)
  category.define(:celsius) do |measurement|
    measurement.to { |value| value + 273.15 }
    measurement.from { |value| value - 273.15 }
  end

  category.define(:fahrenheit) do |measurement|
    measurement.to { |value| 5.0/9.0 * (value - 32.0) + 273.0 }
    measurement.from { |value|  9.0/5.0 * (value - 273.0) + 32.0 }
  end
end
```

### Alchemist.unit

`Alchemist.unit` is used to create a measurement. It returns an `Alchemist::Unit`. The `Alchemist::Unit` can be used to perform mathematical operations and conversions. The first argument is how many of the unit you want and the second argument is the name of the unit.

```ruby
Alchemist.unit(1, 'meter')
```

Alchemist will use whatever the last definition for the specified unit. If you need to clarify a category, you may pass it as a third argument.

```ruby
Alchemist.unit(1, 'meter', :distance)
```

### Alchemist.load

Alchemist provides many standard units of measurement which can be included by calling `Alchemist.load`. To find the list of units that can be included view lib/alchemist/units

```ruby
Alchemist.load(:distance)
```

While not suggested, you may load all of Alchemist's built in units by calling `Alchemist.load(:all)`.

## Alchemist::Unit

Alchemist::Unit is the main class for dealing with measurements. You can use this class to convert between measurements or perform mathematical operations. `Alchemist::Unit` supports `+`,`-`,`*`,`/`, and `**`.

### #to

This method will convert a unit from one measurement to another

```ruby
Alchemist.unit(1.0, :meter).to(:feet) # 3.28084 feet
```

If you don't provide an argument to `to` then it will return an `Alchemist::Conversion`. Any method called on `Alchemist::Conversion` will attempt to convert the unit into the new measurement.

```ruby
Alchemist.unit(1.0, :meter).to.feet # 3.28084 feet

conversion = Alchemist.unit(1.0, :meter).to # Alchemist::Conversion
conversion.feet # 3.28084 feet
conversion.inches # 39.3701 inches
```

### #+

Adds two units together. The right hand unit will always be converted into the left hand unit. Both operands must be `Alchemist::Unit`s and must be in the same category.

```ruby
meter = Alchemist.unit(1.0, :meter)
foot = Alchemist.unit(1.0, :foot)

meter + meter # 2 meters
meter + foot # 1.3048 meters
```

### #-

Subtract two units. The right hand unit will always be converted into the left hand unit. Both operands must be `Alchemist::Unit`s and must be in the same category.

```ruby
meter = Alchemist.unit(1.0, :meter)
foot = Alchemist.unit(1.0, :foot)

meter - meter # 0 meters
meter - foot # 0.6952 meters
```

### #*

Multiply a unit. You may multiply by a numerical value or another `Alchemist::Unit`. Multiplying by another `Alchemist::Unit` will change the dimension of the unit.

```ruby
meter = Alchemist.unit(1.0, :meter)
second = Alchemist.unit(1.0, :second)

meter * 2 # 2 meters
meter * meter # 1 meter squared
meter * second # 1 meter second
```

### #/

Multiply a unit. You may divide by a numerical value or another `Alchemist::Unit`. Dividing by another `Alchemist::Unit` will change the dimension of the unit.

```ruby
meter = Alchemist.unit(1.0, :meter)
second = Alchemist.unit(1.0, :second)

meter / 2 # 0.5 meters
meter / meter # 1
meter / second # 1 meter per second
```

### #**

Changes the dimension of a unit. The right hand operand must be a numeric value.

```ruby
meter = Alchemist.unit(1.0, :meter)
meter ** 2 # 1 meter squared
meter ** 3 # 1 meter cubed
```

## Syntactical Sugar

Alchemist provides a few options for syntactical sugar. These are provided by modules you may mix in.

### Alchemist::UnitExt

`Alchemist::UnitExt` will add a unit method to your class which will provide the instance as the first argument to Alchemist.unit. Your unit must respond to `to_f`.

```ruby
class Float
  include Alchemist::UnitExt
end

1.0.unit('meter') # the same as calling Alchemist.unit(1.0.to_f, 'meter')
```

### Alchemist::Category

`Alchemist::Category` is used to dynamically create a module to mix in to your class. Mixing this module in will add methods for all of the units defined in the module.

```ruby
Alchemist.register(:distance) do |category|
  category.define :meter, 1.0
end

class Float
  include Alchemist::Category.units(:distance)
end

1.0.meter
```

You may also include all categories by using `Alchemist::Category.all`. This method is not preferred due to it polluting the interface of your class.

### Alchemist::NumericExt (Deprecated)

WARNING: This module can have unforseen performance impacts on your application due to it's usage of method missing. This module has been included for legacy reasons and will be removed in Alchemist 0.3.0

This module will provide method_missing that will perform a lookup to see if a unit has been defined with the method name.

```ruby
Alchemist.register(:distance) do |category|
  category.define :meter, 1.0
end

class Numeric
  include NumericExt
end

1.0.meter # this uses method_missing
```

## Installation

`gem install alchemist`

## Todo

Be able to define units in terms of other units. For example a Newton is 1 kg * (m / s^2)

```ruby
kg = Alchemist.unit(1000.0, :grams)
m = Alchemist.unit(1.0, :meter)
s = Alchemist.unit(1.0, :second)

Alchemist.register(:force) do |category|
  category.define_derived_unit(:Newton, ->{ kg * m / s ** 2 })
end

I am currently not sure about the syntax or how this would be handled.


```
