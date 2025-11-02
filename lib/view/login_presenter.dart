import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Presenter para a tela de login seguindo o padrão do material do professor.
/// Cada método retorna `Future<bool>` indicando sucesso (true) ou falha/cancelamento (false).
class LoginPresenter {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Método para autenticação com Google.
  /// Retorna `true` se o login foi bem-sucedido, `false` caso o usuário cancele
  /// ou ocorra algum erro.
  Future<bool> signInWithGoogle() async {
    try {
      // Inicia o fluxo de login com Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Caso o usuário cancele o login, retorna falso
      if (googleUser == null) return false;

      // Obtém as credenciais de autenticação do Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Cria uma credencial do Firebase a partir das credenciais do Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Realiza o sign-in no Firebase com a credencial do Google
      final userCred = await _auth.signInWithCredential(credential);

      return userCred.user != null;
    } catch (_) {
      return false;
    }
  }

  /// Faz login com email/senha; retorna true se bem sucedido.
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCred.user != null;
    } catch (_) {
      return false;
    }
  }

  /// Registra novo usuário com email/senha; retorna true se criado.
  Future<bool> registerWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCred.user != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
