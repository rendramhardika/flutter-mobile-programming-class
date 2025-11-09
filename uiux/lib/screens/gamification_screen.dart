import 'package:flutter/material.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen> {
  // User progress data
  int _points = 1500;
  int _level = 3;
  int _nextLevelPoints = 1000;
  double get _progress => _points / _nextLevelPoints;

  // Sample achievements data
  final List<Achievement> _achievements = [
    Achievement(
      title: 'Pemula',
      description: 'Selesaikan 5 tugas pertama',
      icon: Icons.emoji_events,
      isUnlocked: true,
      progress: 1.0,
    ),
    Achievement(
      title: 'Ahli Konten',
      description: 'Buat 10 konten',
      icon: Icons.article,
      isUnlocked: true,
      progress: 0.8,
    ),
    Achievement(
      title: 'Sosial Media',
      description: 'Bagikan 5 kali',
      icon: Icons.share,
      isUnlocked: false,
      progress: 0.4,
    ),
  ];

  // Sample leaderboard data
  final List<LeaderboardUser> _leaderboard = [
    LeaderboardUser(name: 'Anda', points: 750, rank: 4, isCurrentUser: true),
    LeaderboardUser(name: 'Budi Santoso', points: 1200, rank: 1, isCurrentUser: false),
    LeaderboardUser(name: 'Ani Lestari', points: 1100, rank: 2, isCurrentUser: false),
    LeaderboardUser(name: 'Citra Dewi', points: 950, rank: 3, isCurrentUser: false),
    LeaderboardUser(name: 'Doni Kurniawan', points: 600, rank: 5, isCurrentUser: false),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gamifikasi'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.emoji_events), text: 'Pencapaian'),
              Tab(icon: Icon(Icons.leaderboard), text: 'Peringkat'),
              Tab(icon: Icon(Icons.card_giftcard), text: 'Hadiah'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.white],
            ),
          ),
          child: TabBarView(
            children: [
              _buildAchievementsTab(),
              _buildLeaderboardTab(),
              _buildRewardsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User progress card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level $_level',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_points XP',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_nextLevelPoints - _points} XP menuju Level ${_level + 1}',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pencapaian Anda',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._achievements.map((achievement) => _buildAchievementCard(achievement)).toList(),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: achievement.isUnlocked ? Colors.blue.shade50 : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(
            achievement.icon,
            color: achievement.isUnlocked ? Colors.blue : Colors.grey,
            size: 28,
          ),
        ),
        title: Text(
          achievement.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            const SizedBox(height: 4),
            if (!achievement.isUnlocked)
              LinearProgressIndicator(
                value: achievement.progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
          ],
        ),
        trailing: achievement.isUnlocked
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Current user's rank
          Card(
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              title: const Text('Peringkat Anda'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Peringkat ${_leaderboard.firstWhere((user) => user.isCurrentUser).rank}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Leaderboard list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _leaderboard.length,
            itemBuilder: (context, index) {
              final user = _leaderboard[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: user.isCurrentUser ? Colors.blue.shade50 : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: user.isCurrentUser
                        ? Colors.blue
                        : Colors.grey.shade300,
                    child: Text(
                      user.isCurrentUser ? 'A' : user.name[0],
                      style: TextStyle(
                        color: user.isCurrentUser ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(
                      fontWeight:
                          user.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${user.points} XP',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: user.rank <= 3
                              ? Colors.amber.shade100
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#${user.rank}',
                          style: TextStyle(
                            color: user.rank <= 3 ? Colors.amber.shade900 : Colors.grey.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsTab() {
    // Data hadiah yang tersedia
    final List<Reward> rewards = [
      Reward(
        title: 'Voucher Belanja Rp50.000',
        description: 'Dapat digunakan di berbagai merchant online',
        points: 1000,
        icon: Icons.shopping_bag,
        color: Colors.blue,
        isClaimed: _points >= 1000,
      ),
      Reward(
        title: 'Diskon 30% Produk Pilihan',
        description: 'Dapatkan diskon spesial untuk produk pilihan',
        points: 1500,
        icon: Icons.discount,
        color: Colors.green,
        isClaimed: _points >= 1500,
      ),
      Reward(
        title: 'E-Book Eksklusif',
        description: 'Akses ke koleksi e-book premium',
        points: 2000,
        icon: Icons.menu_book,
        color: Colors.orange,
        isClaimed: _points >= 2000,
      ),
      Reward(
        title: 'Konsultasi Gratis',
        description: 'Sesi konsultasi 1-on-1 dengan ahli',
        points: 3000,
        icon: Icons.people,
        color: Colors.purple,
        isClaimed: _points >= 3000,
      ),
      Reward(
        title: 'Premium Membership 1 Bulan',
        description: 'Nikmati semua fitur premium selama 1 bulan',
        points: 5000,
        icon: Icons.star,
        color: Colors.amber,
        isClaimed: _points >= 5000,
      ),
    ];

    return Column(
      children: [
        // Header dengan poin pengguna
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium, color: Colors.purple),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Poin Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$_points XP',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Daftar hadiah
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: rewards.length,
            itemBuilder: (context, index) {
              final reward = rewards[index];
              return _buildRewardCard(reward);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard(Reward reward) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: reward.color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(reward.icon, color: reward.color, size: 24),
        ),
        title: Text(
          reward.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(reward.description),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${reward.points} XP',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (reward.isClaimed)
                  const Text(
                    'Telah Diklaim',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else if (_points >= reward.points)
                  ElevatedButton(
                    onPressed: () {
                      // Aksi untuk mengklaim hadiah
                      _claimReward(reward);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text('Klaim Sekarang'),
                  )
                else
                  Text(
                    'Butuh ${reward.points - _points} XP lagi',
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _claimReward(Reward reward) {
    // Tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klaim Hadiah'),
        content: Text('Anda yakin ingin menukarkan ${reward.points} XP untuk ${reward.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Logika untuk mengklaim hadiah
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selamat! ${reward.title} berhasil diklaim'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Ya, Klaim'),
          ),
        ],
      ),
    );
  }
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final double progress;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.progress,
  });
}

class LeaderboardUser {
  final String name;
  final int points;
  final int rank;
  final bool isCurrentUser;

  LeaderboardUser({
    required this.name,
    required this.points,
    required this.rank,
    required this.isCurrentUser,
  });
}

class Reward {
  final String title;
  final String description;
  final int points;
  final IconData icon;
  final Color color;
  final bool isClaimed;

  Reward({
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.color,
    required this.isClaimed,
  });
}
