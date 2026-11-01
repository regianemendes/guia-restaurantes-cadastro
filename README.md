# Guia de Restaurantes (Cadastro e Requisições REST)

Aplicativo desenvolvido em **Flutter** para a disciplina de **Programação para Dispositivos Móveis II** (Fatec Atibaia). O projeto implementa o fluxo completo de cadastro de usuários integrado a um servidor REST remoto, utilizando a arquitetura **MVVM** (Model-View-ViewModel) e o pacote **Dio** para requisições HTTP.

---

## 🚀 O que foi construído até a Aula 13

* **Tela de Cadastro (`SignUpPage`)**: Interface em `StatefulWidget` contendo campos validados para Nome, E-mail, Celular, Senha e Confirmação de senha, além de checkbox interativo para aceite dos termos de uso.
* **Validação e Regras de Negócio (`SignUpViewmodel`)**: Regras de validação desacopladas do Flutter em Dart puro, garantindo que o contrato de erro retorne `null` em caso de sucesso ou uma mensagem textual amigável em caso de falha.
* **Camada de Dados (Data Layer)**:
  * **Model (`User`)**: Estrutura de dados com serialização `toJson()`.
  * **Requester (`Requester`)**: Configuração centralizada do cliente HTTP **Dio** (URL base, timeouts e tratamento de exceções de rede customizadas).
  * **Service (`UserService`)**: Gerenciamento de endpoints específicos (`/api/v1/auth/register`).
  * **Repository (`UserRepository`)**: Intermediário isolando a fonte de dados do ViewModel.
* **Tratamento de Estado e Assincronismo**: Uso de `Future`, `async/await`, indicadores visuais de carregamento (`isLoading`) e proteção do botão de envio contra múltiplos toques simultâneos.

---

## 🛠️ Tecnologias e Ferramentas Utilizadas

* **Flutter / Dart**
* **Dio** (Cliente HTTP para requisições REST)
* **Arquitetura MVVM** (Separação de responsabilidades: View, ViewModel, Repository, Service, Requester)
* **Android Studio** (Ambiente de desenvolvimento)

---
