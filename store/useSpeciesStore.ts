import { create } from 'zustand';
import { supabase } from '@/lib/supabase';
import type { MarineSpecies, MarineCategory } from '@/types/database';

interface SpeciesState {
  species: MarineSpecies[];
  filteredSpecies: MarineSpecies[];
  selectedCategory: MarineCategory | 'All';
  searchQuery: string;
  isLoading: boolean;

  fetchSpecies: () => Promise<void>;
  setCategory: (category: MarineCategory | 'All') => void;
  setSearchQuery: (query: string) => void;
  getSpeciesById: (id: string) => MarineSpecies | undefined;
}

export const useSpeciesStore = create<SpeciesState>((set, get) => ({
  species: [],
  filteredSpecies: [],
  selectedCategory: 'All',
  searchQuery: '',
  isLoading: false,

  fetchSpecies: async () => {
    set({ isLoading: true });
    try {
      const { data, error } = await supabase
        .from('marine_species')
        .select('*')
        .order('name_kr');

      if (error) throw error;

      set({
        species: data || [],
        filteredSpecies: data || [],
      });
    } catch (error) {
      console.error('Error fetching species:', error);
    } finally {
      set({ isLoading: false });
    }
  },

  setCategory: (category) => {
    const { species, searchQuery } = get();

    let filtered = species;

    if (category !== 'All') {
      filtered = filtered.filter((s) => s.category === category);
    }

    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(
        (s) =>
          s.name_kr.toLowerCase().includes(query) ||
          s.name_en.toLowerCase().includes(query) ||
          s.scientific_name.toLowerCase().includes(query)
      );
    }

    set({ selectedCategory: category, filteredSpecies: filtered });
  },

  setSearchQuery: (query) => {
    const { species, selectedCategory } = get();

    let filtered = species;

    if (selectedCategory !== 'All') {
      filtered = filtered.filter((s) => s.category === selectedCategory);
    }

    if (query) {
      const lowerQuery = query.toLowerCase();
      filtered = filtered.filter(
        (s) =>
          s.name_kr.toLowerCase().includes(lowerQuery) ||
          s.name_en.toLowerCase().includes(lowerQuery) ||
          s.scientific_name.toLowerCase().includes(lowerQuery)
      );
    }

    set({ searchQuery: query, filteredSpecies: filtered });
  },

  getSpeciesById: (id) => {
    return get().species.find((s) => s.id === id);
  },
}));
