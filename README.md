# MY-SWAPI-GEM

MY-SWAPI-GEM é uma solução, para Rails, que possibilita manter o banco de dados atualizado em sincronia com a API de Star Wars (https://swapi.dev/), além de fazer buscas para todos os endpoints. A gem foi feita para o projeto MYSWAPI-RAILS.

## Instalação

Atualmente a compatibilidade foi testada apenas com mongodb.

Adicionado ao seu Gemfile:
```ruby
gem 'myswapigem', git: 'git@github.com:debugferro/MYSWAPIGEM.git', branch: 'master'
```

Depois execute:

    $ bundle install

Ou instale você mesmo através do comando:

    $ gem install myswapigem

## Uso

MY-SWAPI-GEM segue o mesmo esquema da API: todos os modelos possuem as mesmas relações apresentadas no site oficial. Por isso, para fazer a utilização da rake task que popula o banco de dados, é imprecindível que o banco de dados de sua aplicação possua a mesma estrutura.

Para executar a tarefa digite no terminal:

    $ rake myswapigem:populate

A tarefa verificará seu banco de dados, adicionando novos dados que por ventura sejam adicionados pela API, e manterá seus dados atualizados caso haja uma alteração de qualquer um dos lados. As associações também são criadas.

Caso queira desativar as atualizações para dados existentes, crie uma variável de ambiente chamada 'diable_update' e coloque como 'true'.
```yml
ENV['disable_update']: 'true'
```

Como a busca por título, nome, ou quaisquer outras variáveis não é confiável para a comparação sobre a pré-existência ou não de um dado, a atualização dos dados é feita por comparações entre as url's que foram obtidos os dados. Assim, é possível saber se aquele dado é o mesmo que existe em nosso banco de dados. Caso queira personalizar o parâmetro de busca, crie uma variável de ambiente seguindo o modelo "search _#{tipo_do_recurso}_by"="#{nome_do_recurso}".
Exemplo:
```yml
ENV['search_film_by']: 'title'
ENV['search_people_by']: 'name'
```
Lembrando: para todos o padrão é 'url', visto a confiabilidade.

Caso a tarefa não lhe seja interessante, ainda é possível fazer as requisições para a API através da gem:

Após o namespace da gem, segue-se o tipo de recurso que busca. Após declarar o novo objeto, chame o método index especificando qual página deseja obter.

```ruby
people = MYSWAPIGEM::People.new
people.index(1)
 # => [{:name=>"Luke Skywalker", :height=>"172", :mass=>"77", :hair_color=>"blond", :skin_color=>"fair", :eye_color=>"blue", :birth_year=>"19BBY", :gender=>"male", :homeworld=>"http://swapi.dev/api/planets/1/", :films=>["http://swapi.dev/api/films/1/", "http://swapi.dev/api/films/2/", "http://swapi.dev/api/films/3/", "http://swapi.dev/api/films/6/"] ...
```
Há também o método find, para obter um recurso em específico através do id.

```ruby
film = MYSWAPIGEM::Film.new
film.find(4)
 # => {:title=>"The Phantom Menace", :episode_id=>1, :opening_crawl=>"Turmoil has engulfed the\r\nGalactic Republic. The taxation\r\nof trade routes to outlying star\r\nsystems is in dispute.\r\n\r\nHoping to resolve the matter\r\nwith a blockade of deadly\r\nbattleships, the greedy Trade\r\nFederation has stopped all\r\nshipping to the small planet\r\nof Naboo.\r\n\r\nWhile the Congress of the\r\nRepublic endlessly debates\r\nthis alarming chain of events,\r\nthe Supreme Chancellor has\r\nsecretly dispatched two Jedi\r\nKnights, the guardians of\r\npeace and justice in the\r\ngalaxy, to settle the conflict....", :director=>"George Lucas", :producer=>"Rick McCallum", :release_date=>"1999-05-19" ...
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
