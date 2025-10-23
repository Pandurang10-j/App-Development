import React, { useState } from 'react';
import { 
  View, Text, TextInput, FlatList, Image, 
  TouchableOpacity, StyleSheet, ActivityIndicator, Linking 
} from 'react-native';
import axios from 'axios';

interface Anime {
  mal_id: number;
  title: string;
  images: { jpg: { image_url: string } };
  synopsis: string;
  score: number;
  type: string;
  year: number;
  episodes: number;
  url: string;
}

export default function App() {
  const [query, setQuery] = useState('');
  const [animeList, setAnimeList] = useState<Anime[]>([]);
  const [loading, setLoading] = useState(false);
  const [filterType, setFilterType] = useState(''); // TV, Movie, OVA
  const [sortBy, setSortBy] = useState('popularity'); // popularity, rating

  const searchAnime = async () => {
    if (!query.trim()) return;
    setLoading(true);
    try {
      const res = await axios.get(`https://api.jikan.moe/v4/anime?q=${query}&order_by=${sortBy}&sort=asc`);
      let results = res.data.data;

      // Apply filter by type (TV, Movie, OVA)
      if (filterType) {
        results = results.filter((item: Anime) => item.type === filterType);
      }

      setAnimeList(results);
    } catch (error) {
      console.error(error);
      alert('Error fetching anime data.');
    }
    setLoading(false);
  };

  const renderItem = ({ item }: { item: Anime }) => (
    <TouchableOpacity 
      style={styles.card}
      onPress={() => Linking.openURL(item.url)} // open anime in browser
    >
      <Image source={{ uri: item.images.jpg.image_url }} style={styles.image} />
      <View style={styles.info}>
        <Text style={styles.title}>{item.title}</Text>
        <Text style={styles.details}>
          🎬 {item.type || 'Unknown'} | ⭐ {item.score || 'N/A'} | 📅 {item.year || '—'}
        </Text>
        <Text numberOfLines={3} style={styles.synopsis}>{item.synopsis || 'No description available.'}</Text>
        <Text style={styles.link}>Tap for more details →</Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.header}>🎌 Anime Search Pro</Text>

      <TextInput
        style={styles.input}
        placeholder="Search anime..."
        value={query}
        onChangeText={setQuery}
        onSubmitEditing={searchAnime}
      />

      <View style={styles.filterRow}>
        <TouchableOpacity onPress={() => setFilterType('')} style={[styles.filterBtn, !filterType && styles.activeBtn]}>
          <Text style={styles.filterText}>All</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setFilterType('TV')} style={[styles.filterBtn, filterType === 'TV' && styles.activeBtn]}>
          <Text style={styles.filterText}>TV</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setFilterType('Movie')} style={[styles.filterBtn, filterType === 'Movie' && styles.activeBtn]}>
          <Text style={styles.filterText}>Movies</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setFilterType('OVA')} style={[styles.filterBtn, filterType === 'OVA' && styles.activeBtn]}>
          <Text style={styles.filterText}>OVA</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.filterRow}>
        <TouchableOpacity onPress={() => setSortBy('popularity')} style={[styles.filterBtn, sortBy === 'popularity' && styles.activeBtn]}>
          <Text style={styles.filterText}>Popularity</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setSortBy('score')} style={[styles.filterBtn, sortBy === 'score' && styles.activeBtn]}>
          <Text style={styles.filterText}>Rating</Text>
        </TouchableOpacity>
      </View>

      <TouchableOpacity style={styles.searchBtn} onPress={searchAnime}>
        <Text style={styles.searchText}>🔍 Search</Text>
      </TouchableOpacity>

      {loading ? (
        <ActivityIndicator size="large" color="#ff6600" />
      ) : (
        <FlatList
          data={animeList}
          keyExtractor={(item) => item.mal_id.toString()}
          renderItem={renderItem}
          contentContainerStyle={{ paddingBottom: 100 }}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, backgroundColor: '#fff' },
  header: { fontSize: 26, fontWeight: 'bold', textAlign: 'center', marginBottom: 10, color: '#333' },
  input: { borderWidth: 1, borderColor: '#ccc', borderRadius: 10, padding: 10, marginBottom: 10 },
  filterRow: { flexDirection: 'row', justifyContent: 'space-around', marginBottom: 10 },
  filterBtn: { borderWidth: 1, borderColor: '#ff6600', borderRadius: 10, paddingVertical: 5, paddingHorizontal: 10 },
  activeBtn: { backgroundColor: '#ff6600' },
  filterText: { color: '#333', fontWeight: '500' },
  searchBtn: { backgroundColor: '#ff6600', padding: 10, borderRadius: 10, alignItems: 'center', marginBottom: 10 },
  searchText: { color: '#fff', fontWeight: 'bold', fontSize: 16 },
  card: { flexDirection: 'row', marginBottom: 10, backgroundColor: '#f9f9f9', borderRadius: 10, overflow: 'hidden', elevation: 3 },
  image: { width: 100, height: 140 },
  info: { flex: 1, padding: 10 },
  title: { fontWeight: 'bold', fontSize: 16, color: '#222' },
  details: { fontSize: 13, color: '#666', marginTop: 4 },
  synopsis: { fontSize: 13, color: '#444', marginTop: 5 },
  link: { fontSize: 12, color: '#ff6600', marginTop: 5, fontStyle: 'italic' },
});
