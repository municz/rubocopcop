RuboCopCop: cop that checks Rubocop's cops
==========================================

První úkol do předmětu Ruby PV249.

Zadání
------

[Rubocop](https://github.com/bbatsov/rubocop) je nástroj na stylovou kontrolu Ruby kódu.
 Konfiguruje se pomocí `.rubocop.yml` souboru. Pravidl pro Rubocop se jměnuje `cop`.

`rubocop --show-cops` vypíše konfiguraci všech pravidel pro aktuální adresář.

Vašim úkolem bude naspat script `rubocopcop.rb`, který se bude chovat následovně:

1. v případě, že je spuštěn v adresáři, kde žádný `.rubocop.yml` není, zkopíruje tam svůj
   `.rubocop.yml` soubor

2. v případě, že `.rubocop.yml` soubor už existuje, upraví ho následovně:
  * odstraní u nastavení pravidel klíče `Description`, `StyleGuide` a `SupportedStyles`,
  tyto hodnoty budou vždy použité z defaultního nastavení.
  * vezme nastavení, které generuje `rubocop --show-cops` a přepíše ním `.rubocop.yml` soubor.
  Pozor ale na nastavení `AllCops`, které `rubocop --show-cops` nevypíše, a je potřeba ho z původní
  konfigurace převzít explicitně.

3. `rake` spustí kontroly pro úkol: rubocop a testy. Před prvním spuštěním nezapomeňte
na `bundle install`.
  * `rake rubocop` spustí pouze rubocop
  * `rake test` spustí pouze testy

Podmínky pro uznání řešení:

1. budete upravovat jen soubor `rubocopcop.rb`
2. script bude pracovat podle zadání
3. příkaz `rake` proběhne úspěšně

Může se hodit
-------------

* [YAML RDoc](https://ruby-doc.org/stdlib-2.2.1/libdoc/yaml/rdoc/YAML.html)
* [Hash](https://docs.ruby-lang.org/en/2.2.0/Hash.html)

Odevzdání
---------

* Do 9. 10. 2016 (včetně)
* Konzultace k úkolu na cvičení 3. 10.
* Způsob odevzdání: bude upřesněn na přednášce 3. 10. věnované nástroji `git`
