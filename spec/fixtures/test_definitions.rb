Alchemist::DefaultDictionary.instance.define(:length) do
  meter plural: :meters, short: :m
  metre plural: :metres, short: :m
  foot meters(0.3048), plural: :feet, short: :ft
  inch meters(0.0254), plural: :inches, short: :in
end
