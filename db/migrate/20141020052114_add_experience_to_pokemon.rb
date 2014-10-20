class AddExperienceToPokemon < ActiveRecord::Migration
  def change
    add_column :pokemons, :experience, :integer, :null => false, :default => 0
  end
end
