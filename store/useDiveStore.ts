import { create } from 'zustand';
import { supabase } from '@/lib/supabase';
import type { Dive, DiveDetail, MarineSighting } from '@/types/database';

interface DiveState {
  dives: Dive[];
  currentDive: Dive | null;
  currentDiveDetails: DiveDetail | null;
  sightings: MarineSighting[];
  isLoading: boolean;

  fetchDives: () => Promise<void>;
  fetchDiveById: (id: string) => Promise<void>;
  createDive: (dive: Partial<Dive>) => Promise<Dive | null>;
  updateDive: (id: string, updates: Partial<Dive>) => Promise<void>;
  deleteDive: (id: string) => Promise<void>;
  addSighting: (sighting: Partial<MarineSighting>) => Promise<void>;
}

export const useDiveStore = create<DiveState>((set, get) => ({
  dives: [],
  currentDive: null,
  currentDiveDetails: null,
  sightings: [],
  isLoading: false,

  fetchDives: async () => {
    set({ isLoading: true });
    try {
      const { data, error } = await supabase
        .from('dives')
        .select('*')
        .order('date', { ascending: false });

      if (error) throw error;
      set({ dives: data || [] });
    } catch (error) {
      console.error('Error fetching dives:', error);
    } finally {
      set({ isLoading: false });
    }
  },

  fetchDiveById: async (id: string) => {
    set({ isLoading: true });
    try {
      const [diveResult, detailsResult, sightingsResult] = await Promise.all([
        supabase.from('dives').select('*').eq('id', id).single(),
        supabase.from('dive_details').select('*').eq('dive_id', id).single(),
        supabase
          .from('marine_sightings')
          .select('*, species:marine_species(*)')
          .eq('dive_id', id),
      ]);

      if (diveResult.error) throw diveResult.error;

      set({
        currentDive: diveResult.data,
        currentDiveDetails: detailsResult.data || null,
        sightings: sightingsResult.data || [],
      });
    } catch (error) {
      console.error('Error fetching dive:', error);
    } finally {
      set({ isLoading: false });
    }
  },

  createDive: async (dive) => {
    try {
      const { data, error } = await supabase
        .from('dives')
        .insert(dive)
        .select()
        .single();

      if (error) throw error;

      set((state) => ({
        dives: [data, ...state.dives],
      }));

      return data;
    } catch (error) {
      console.error('Error creating dive:', error);
      return null;
    }
  },

  updateDive: async (id, updates) => {
    try {
      const { data, error } = await supabase
        .from('dives')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

      if (error) throw error;

      set((state) => ({
        dives: state.dives.map((d) => (d.id === id ? data : d)),
        currentDive: state.currentDive?.id === id ? data : state.currentDive,
      }));
    } catch (error) {
      console.error('Error updating dive:', error);
    }
  },

  deleteDive: async (id) => {
    try {
      const { error } = await supabase.from('dives').delete().eq('id', id);

      if (error) throw error;

      set((state) => ({
        dives: state.dives.filter((d) => d.id !== id),
      }));
    } catch (error) {
      console.error('Error deleting dive:', error);
    }
  },

  addSighting: async (sighting) => {
    try {
      const { data, error } = await supabase
        .from('marine_sightings')
        .insert(sighting)
        .select('*, species:marine_species(*)')
        .single();

      if (error) throw error;

      set((state) => ({
        sightings: [...state.sightings, data],
      }));
    } catch (error) {
      console.error('Error adding sighting:', error);
    }
  },
}));
