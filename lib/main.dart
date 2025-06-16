import 'package:flutter/material.dart';
import 'dart:async';
import 'core/services/auth_service.dart';
import 'features/swipe/swipe_service.dart' as swipe;
import 'features/chat/chat_service.dart';
import 'features/profile/photo_management_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/notifications/notification_service.dart';
import 'features/security/identity_verification_service.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

void main() {
  runApp(const CitasApp());
}

class CitasApp extends StatelessWidget {
  const CitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citas App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE91E63),
              Color(0xFFAD1457),
              Color(0xFF880E4F),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 400 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo animado
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Título principal
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Citas App',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isWeb ? 56 : 48,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Encuentra tu pareja perfecta',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: isWeb ? 22 : 18,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 64),

                    // Botones de acción
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AuthScreen(isLogin: false),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFE91E63),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                ),
                                child: Text(
                                  'Crear Cuenta',
                                  style: TextStyle(
                                    fontSize: isWeb ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AuthScreen(isLogin: true),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.white, width: 2),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontSize: isWeb ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Información adicional
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Conecta con personas especiales cerca de ti',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: isWeb ? 16 : 14,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Pantalla principal con navegación
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _unreadNotifications = 0;

  final List<Widget> _screens = [
    const SwipeScreen(),
    const MatchesScreen(),
    const ChatScreen(),
    const ProfileScreen(),
    const ConnectionScreen(), // Nueva pantalla de conexión
  ];

  @override
  void initState() {
    super.initState();
    _loadUnreadNotifications();
  }

  Future<void> _loadUnreadNotifications() async {
    try {
      final count = await NotificationService.getUnreadCount();
      if (mounted) {
        setState(() {
          _unreadNotifications = count;
        });
      }
    } catch (e) {
      // Error silencioso
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.swipe),
            label: 'Descubrir',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Conectar',
          ),
        ],
      ),
    );
  }
}

// Pantalla de swipe
class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final CardSwiperController controller = CardSwiperController();
  List<swipe.UserProfile> profiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  void _loadProfiles() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      profiles = swipe.SwipeService.generateDemoProfiles();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubrir'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Botón de notificaciones con badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              // Badge de notificaciones no leídas
              FutureBuilder<int>(
                future: NotificationService.getUnreadCount(),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  if (count == 0) return const SizedBox.shrink();

                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              _showFilters();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Buscando perfiles cerca de ti...'),
                ],
              ),
            )
          : profiles.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay más perfiles disponibles',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Vuelve más tarde para ver nuevos perfiles',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Área de swipe
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CardSwiper(
                          controller: controller,
                          cardsCount: profiles.length,
                          onSwipe: _onSwipe,
                          onUndo: _onUndo,
                          numberOfCardsDisplayed: 3,
                          backCardOffset: const Offset(40, 40),
                          padding: const EdgeInsets.all(24.0),
                          cardBuilder: (context,
                              index,
                              horizontalThresholdPercentage,
                              verticalThresholdPercentage) {
                            return swipe.ProfileCard(profile: profiles[index]);
                          },
                        ),
                      ),
                    ),

                    // Botones de acción
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botón de rechazar
                          FloatingActionButton(
                            onPressed: () {
                              controller.swipe(CardSwiperDirection.left);
                            },
                            backgroundColor: Colors.grey.shade100,
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),

                          // Botón de deshacer
                          FloatingActionButton(
                            onPressed: () {
                              controller.undo();
                            },
                            backgroundColor: Colors.grey.shade100,
                            child: const Icon(
                              Icons.undo,
                              color: Colors.blue,
                              size: 25,
                            ),
                          ),

                          // Botón de me gusta
                          FloatingActionButton(
                            onPressed: () {
                              controller.swipe(CardSwiperDirection.right);
                            },
                            backgroundColor: Colors.pink.shade100,
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    final profile = profiles[previousIndex];

    if (direction == CardSwiperDirection.right) {
      // Me gusta
      _handleLike(profile);
    } else if (direction == CardSwiperDirection.left) {
      // No me gusta
      _handlePass(profile);
    }

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint('Deshecho: ${profiles[currentIndex].name}');
    return true;
  }

  void _handleLike(swipe.UserProfile profile) {
    // Simular posible match
    final isMatch = DateTime.now().millisecond % 3 == 0; // 33% de probabilidad

    if (isMatch) {
      _showMatchDialog(profile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Te gusta ${profile.name}'),
          backgroundColor: Colors.pink,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _handlePass(swipe.UserProfile profile) {
    debugPrint('Pasado: ${profile.name}');
  }

  void _showMatchDialog(swipe.UserProfile profile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡Es un Match!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A ti y a ${profile.name} se han gustado mutuamente',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: const Text('Seguir explorando'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navegar a chat (implementar después)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFE91E63),
                        ),
                        child: const Text('Enviar mensaje'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtros de Búsqueda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Distancia máxima'),
                subtitle: const Text('50 km'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Rango de edad'),
                subtitle: const Text('18 - 35 años'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.interests),
                title: const Text('Intereses'),
                subtitle: const Text('Cualquiera'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aplicar filtros'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// Pantalla de matches
class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 100,
              color: Colors.pink,
            ),
            SizedBox(height: 20),
            Text(
              'Tus Matches',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Aquí verás a las personas que te han gustado'),
          ],
        ),
      ),
    );
  }
}

// Pantalla de chat funcional
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatConversation> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      conversations = ChatService.getConversations();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversaciones'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando conversaciones...'),
                ],
              ),
            )
          : conversations.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay conversaciones aún',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Haz match con alguien para empezar a chatear',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return _buildConversationTile(conversation);
                  },
                ),
    );
  }

  Widget _buildConversationTile(ChatConversation conversation) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFE91E63),
              child: Text(
                conversation.participantName.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (conversation.isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation.participantName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              _formatTimestamp(conversation.lastMessage.timestamp),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              conversation.lastMessage.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conversation.unreadCount > 0
                    ? Colors.black87
                    : Colors.grey.shade600,
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
        trailing: conversation.unreadCount > 0
            ? Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFE91E63),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                conversation: conversation,
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buscar conversaciones'),
          content: const TextField(
            decoration: InputDecoration(
              hintText: 'Buscar por nombre...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }
}

// Pantalla de detalle de chat
class ChatDetailScreen extends StatefulWidget {
  final ChatConversation conversation;

  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  late StreamSubscription _messageSubscription;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupMessageListener();
  }

  void _loadMessages() {
    setState(() {
      messages = ChatService.getMessages(widget.conversation.id);
    });
    ChatService.markAsRead(widget.conversation.id);
    _scrollToBottom();
  }

  void _setupMessageListener() {
    _messageSubscription = ChatService.messageStream.listen((message) {
      setState(() {
        messages = ChatService.getMessages(widget.conversation.id);
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFE91E63),
              child: Text(
                widget.conversation.participantName.substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.participantName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.conversation.isOnline ? 'En línea' : 'Desconectado',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              _showComingSoonDialog('Videollamada');
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              _showComingSoonDialog('Llamada');
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Campo de mensaje
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: const Color(0xFFE91E63),
                  child: const Icon(Icons.send, color: Colors.white),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isFromCurrentUser = message.isFromCurrentUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isFromCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isFromCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE91E63),
              child: Text(
                message.senderName.substring(0, 1),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isFromCurrentUser
                    ? const Color(0xFFE91E63)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isFromCurrentUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMessageTime(message.timestamp),
                    style: TextStyle(
                      color: isFromCurrentUser
                          ? Colors.white70
                          : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade400,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      ChatService.sendMessage(
        conversationId: widget.conversation.id,
        message: messageText,
        senderId: 'current_user',
        senderName: 'Tú',
      );
      _messageController.clear();
    }
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature),
          content: Text('$feature estará disponible pronto.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Opciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Bloquear usuario'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Reportar'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Eliminar conversación'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageSubscription.cancel();
    super.dispose();
  }
}

// Pantalla de perfil
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                ),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFFE91E63),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Información del usuario
            const Text(
              'Usuario Demo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'user@demo.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),

            // Opciones del perfil
            _buildProfileOption(
              'Editar Perfil',
              Icons.edit_outlined,
              () {},
            ),
            _buildProfileOption(
              'Mis Fotos',
              Icons.photo_library_outlined,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PhotoManagementScreen(),
                  ),
                );
              },
            ),
            _buildProfileOption(
              'Notificaciones',
              Icons.notifications_outlined,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            _buildProfileOption(
              'Configuración',
              Icons.settings_outlined,
              () {},
            ),
            _buildProfileOption(
              'Ayuda',
              Icons.help_outline,
              () {},
            ),
            _buildProfileOption(
              'Cerrar Sesión',
              Icons.logout,
              () {
                _showLogoutDialog(context);
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFFE91E63),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        tileColor: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cerrar Sesión'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// Pantalla de autenticación
class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({super.key, required this.isLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _securityController =
      TextEditingController(); // Nuevo campo de seguridad
  bool _isObscured = true;
  bool _isLoading = false;
  String? _securityError;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.isLogin ? 'Iniciar Sesión' : 'Crear Cuenta'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE91E63),
        elevation: 1,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 400 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Logo
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E63).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 60,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Campos del formulario
                    if (!widget.isLogin) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu correo';
                        }
                        if (!value.contains('@')) {
                          return 'Por favor ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campo de verificación de seguridad (anti-bot)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🔐 Verificación de Seguridad',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Para tu seguridad, escribe "humano" para verificar que no eres un bot:',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _securityController,
                            decoration: const InputDecoration(
                              hintText: 'Escribe: humano',
                              prefixIcon: Icon(Icons.security),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo requerido para verificación';
                              }
                              if (value.toLowerCase().trim() != 'humano') {
                                return 'Verificación incorrecta';
                              }
                              return null;
                            },
                          ),
                          if (_securityError != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _securityError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Botón principal
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleAuth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                widget.isLogin
                                    ? 'Iniciar Sesión'
                                    : 'Crear Cuenta',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cambiar entre login y registro
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AuthScreen(isLogin: !widget.isLogin),
                          ),
                        );
                      },
                      child: Text(
                        widget.isLogin
                            ? '¿No tienes cuenta? Regístrate'
                            : '¿Ya tienes cuenta? Inicia sesión',
                        style: const TextStyle(color: Color(0xFFE91E63)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuth() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _securityError = null;
      });

      try {
        AuthResult result;

        if (widget.isLogin) {
          // 🔐 VERIFICACIÓN DE IDENTIDAD AVANZADA PARA LOGIN

          // 1. Generar fingerprint del dispositivo y verificar identidad
          await IdentityVerificationService.generateDeviceFingerprint();

          // 2. Verificar autenticidad del usuario
          final verificationResult =
              await IdentityVerificationService.verifyUserAuthenticity(
            userId: _emailController.text.trim(),
            email: _emailController.text.trim(),
          );

          if (!verificationResult.isVerified) {
            setState(() {
              _securityError =
                  'Verificación de identidad fallida: Puntuación de confianza ${verificationResult.trustScorePercentage}';
            });
            return;
          }

          // 3. Proceder con login si la verificación es exitosa
          result = await AuthService.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            humanVerification: _securityController.text.trim(),
          );
        } else {
          // 🛡️ REGISTRO CON VERIFICACIÓN DE IDENTIDAD

          // 1. Verificar que no sea un bot o cuenta duplicada
          final identityCheck =
              await IdentityVerificationService.verifyUserAuthenticity(
            userId: _emailController.text.trim(),
            email: _emailController.text.trim(),
          );

          if (!identityCheck.isVerified) {
            setState(() {
              _securityError =
                  'Error de verificación: Puntuación de confianza muy baja ${identityCheck.trustScorePercentage}';
            });
            return;
          }

          // 2. Proceder con registro
          result = await AuthService.registerWithEmailAndPassword(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            humanVerification: _securityController.text.trim(),
          );
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (result.isSuccess) {
            // Mostrar mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '¡${widget.isLogin ? 'Bienvenido' : 'Cuenta creada exitosamente'}!',
                ),
                backgroundColor: Colors.green,
              ),
            );

            // Navegar a la pantalla principal
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else {
            // Mostrar error
            setState(() {
              _securityError = result.error;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.error ?? 'Error desconocido'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _securityError = 'Error de conexión: ${e.toString()}';
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _securityController.dispose();
    super.dispose();
  }
}

// 🔗 PANTALLA DE CONEXIÓN DE USUARIOS - DEMO BÁSICA
class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _friendCodeController = TextEditingController();
  bool _isLoading = false;
  String? _currentFriendCode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateFriendCode();
  }

  Future<void> _generateFriendCode() async {
    setState(() {
      _currentFriendCode =
          'DEMO${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔗 Conectar Usuarios'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.location_on), text: 'Cerca de Ti'),
            Tab(icon: Icon(Icons.code), text: 'Código Amigo'),
            Tab(icon: Icon(Icons.mail), text: 'Invitaciones'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLocationTab(),
          _buildFriendCodeTab(),
          _buildInvitationsTab(),
        ],
      ),
    );
  }

  Widget _buildLocationTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.location_on, size: 48, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Encuentra usuarios cerca de ti',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Usa tu ubicación para encontrar personas compatibles en tu área',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _showLocationDemo,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: Text(_isLoading ? 'Buscando...' : 'Buscar Usuarios'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.security, size: 48, color: Colors.green),
                    const SizedBox(height: 16),
                    const Text(
                      '🛡️ Funcionalidad de Seguridad Integrada',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '✅ Verificación de identidad avanzada\n'
                      '✅ Prevención anti-bot y anti-suplantación\n'
                      '✅ Geolocalización segura\n'
                      '✅ Códigos de amigo únicos\n'
                      '✅ Sistema de invitaciones encriptadas\n'
                      '✅ Análisis de comportamiento en tiempo real',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: const Text(
                        '🎓 Capstone de Ciberseguridad\n'
                        'Esta app implementa múltiples capas de seguridad para prevenir fraudes, suplantación de identidad y ataques de ingeniería social en aplicaciones de citas.',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendCodeTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tu código de amigo
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.qr_code, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Tu Código de Amigo Seguro',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      _currentFriendCode ?? 'Generando...',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '🔐 Código encriptado y temporal (expira en 24h)',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Buscar por código
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Buscar por Código de Amigo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _friendCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Código de 8 caracteres',
                      hintText: 'DEMO1234',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.code),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 8,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _validateFriendCodeDemo,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar Usuario'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '💡 Códigos de prueba:\n'
                    'DEMOSAFE - Usuario verificado\n'
                    'DEMOTEST - Usuario de prueba',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sistema de Invitaciones Seguras',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shield_outlined,
                        size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text(
                      '🔒 Invitaciones Encriptadas',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Las invitaciones incluyen:\n\n'
                      '• Verificación de identidad del remitente\n'
                      '• Análisis anti-ingeniería social\n'
                      '• Encriptación extremo a extremo\n'
                      '• Expiración automática de seguridad\n'
                      '• Puntuación de confianza del usuario\n'
                      '• Detección de patrones sospechosos',
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _showInvitationDemo,
                      icon: const Icon(Icons.mail),
                      label: const Text('Ver Demo de Invitación'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationDemo() {
    setState(() {
      _isLoading = true;
    });

    // Simular búsqueda
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showDemoResults();
      }
    });
  }

  void _showDemoResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🌍 Usuarios Cercanos Encontrados'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(child: Text('A')),
              title: Text('Ana - 25 años'),
              subtitle: Text('2.3 km • Verificada ✅\nSeguridad: 95%'),
            ),
            ListTile(
              leading: CircleAvatar(child: Text('C')),
              title: Text('Carlos - 28 años'),
              subtitle: Text('4.7 km • Verificado ✅\nSeguridad: 88%'),
            ),
            ListTile(
              leading: CircleAvatar(child: Text('S')),
              title: Text('Sofia - 24 años'),
              subtitle: Text('7.2 km • Pendiente ⏳\nSeguridad: 72%'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _validateFriendCodeDemo() {
    final code = _friendCodeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      _showMessage('Ingresa un código de amigo', isError: true);
      return;
    }

    String message;
    bool isSuccess;

    if (code == 'DEMOSAFE') {
      message =
          '✅ Usuario verificado encontrado!\nNombre: Usuario Demo\nSeguridad: 95%\nEstado: Verificado';
      isSuccess = true;
    } else if (code == 'DEMOTEST') {
      message =
          '⚠️ Usuario encontrado (baja confianza)\nNombre: Usuario Prueba\nSeguridad: 60%\nEstado: No verificado';
      isSuccess = false;
    } else {
      message =
          '❌ Código no válido o expirado\nVerifica que el código sea correcto.';
      isSuccess = false;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSuccess ? '👤 Usuario Encontrado' : '⚠️ Código Inválido'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          if (isSuccess)
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _friendCodeController.clear();
                _showMessage('🚀 Invitación enviada exitosamente!');
              },
              child: const Text('Enviar Invitación'),
            ),
        ],
      ),
    );
  }

  void _showInvitationDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📨 Demo de Invitación Segura'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('De: Usuario_Demo_123'),
            Text('Para: Tu cuenta'),
            Text('Mensaje: "Me gustaría conectar contigo"'),
            SizedBox(height: 12),
            Text('🔐 Verificaciones de Seguridad:'),
            Text('✅ Identidad verificada (95%)'),
            Text('✅ Sin patrones sospechosos'),
            Text('✅ Perfil auténtico'),
            Text('✅ Comportamiento normal'),
            SizedBox(height: 12),
            Text('⏰ Expira en: 6 días, 23 horas'),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMessage('❌ Invitación rechazada');
            },
            child: const Text('Rechazar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showMessage(
                  '✅ Invitación aceptada! Nueva conexión establecida.');
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _friendCodeController.dispose();
    super.dispose();
  }
}
