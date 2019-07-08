/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

// import React, {Fragment} from 'react';
// import {
//   SafeAreaView,
//   StyleSheet,
//   ScrollView,
//   View,
//   Text,
//   StatusBar,
// } from 'react-native';
//
// import {
//   Header,
//   LearnMoreLinks,
//   Colors,
//   DebugInstructions,
//   ReloadInstructions,
// } from 'react-native/Libraries/NewAppScreen';
//
// const App = () => {
//   return (
//     <Fragment>
//       <StatusBar barStyle="light-content" />
//       <SafeAreaView>
//         <ScrollView
//           contentInsetAdjustmentBehavior="automatic"
//           style={styles.scrollView}>
//           <Header />
//           <View style={styles.body}>
//             <View style={styles.sectionContainer}>
//               <Text style={styles.sectionTitle}>Step One</Text>
//               <Text style={styles.sectionDescription}>
//                 Edit <Text style={styles.highlight}>App.js</Text> to change this
//                 screen and then come back to see your edits.
//               </Text>
//             </View>
//             <View style={styles.sectionContainer}>
//               <Text style={styles.sectionTitle}>See Your Changes</Text>
//               <Text style={styles.sectionDescription}>
//                 <ReloadInstructions />
//               </Text>
//             </View>
//             <View style={styles.sectionContainer}>
//               <Text style={styles.sectionTitle}>Debug</Text>
//               <Text style={styles.sectionDescription}>
//                 <DebugInstructions />
//               </Text>
//             </View>
//             <View style={styles.sectionContainer}>
//               <Text style={styles.sectionTitle}>Learn More</Text>
//               <Text style={styles.sectionDescription}>
//                 Read the docs to discover what to do next:
//               </Text>
//             </View>
//             <LearnMoreLinks />
//           </View>
//         </ScrollView>
//       </SafeAreaView>
//     </Fragment>
//   );
// };
//
// const styles = StyleSheet.create({
//   scrollView: {
//     backgroundColor: Colors.lighter,
//   },
//   body: {
//     backgroundColor: Colors.white,
//   },
//   sectionContainer: {
//     marginTop: 32,
//     paddingHorizontal: 24,
//   },
//   sectionTitle: {
//     fontSize: 24,
//     fontWeight: '600',
//     color: Colors.black,
//   },
//   sectionDescription: {
//     marginTop: 8,
//     fontSize: 18,
//     fontWeight: '400',
//     color: Colors.dark,
//   },
//   highlight: {
//     fontWeight: '700',
//   },
// });
import React from 'react';
import { Button, Text, View } from 'react-native';
import { createAppContainer, createStackNavigator } from 'react-navigation';
import { authorize, revoke } from 'react-native-app-auth';

const clientId = 'map-app-client';
const redirectUrl = 'edu.washington.cirg.mapapp:/callback';
const redirectUrlEncoded = 'edu.washington.cirg.mapapp%3A%2Fcallback';

const clientSecret = 'b284cf4f-17e7-4464-987e-3c320b22cfac';

class HomeScreen extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isLoggedIn: false, refreshToken: null };
  }

  static navigationOptions = {
    title: 'Welcome',
  };

  render() {
    const { navigate } = this.props.navigation;
    return (
      <View style={styles.container}>
        <Button
          style={styles.button}
          title="Go to help page"
          onPress={() => navigate('Help')}
        />
        <Button
          style={styles.button}
          title={this.state.isLoggedIn ? 'Logout' : 'Login'}
          onPress={() =>
            this.state.isLoggedIn ? this.mapAppLogout() : this.mapAppLogin()
          }
        />
      </View>
    );
  }

  async mapAppLogin() {
    const config = {
      issuer:
        'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp',
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUrl: redirectUrl,
      scopes: ['openid', 'profile'],
    };

    // Log in to get an authentication token
    authorize(config).then(
      authState => {
        console.log('Access token: ' + authState.accessToken);
        console.log('Refresh token: ' + authState.refreshToken);
        console.log(
          'Access token expiration date: ' + authState.accessTokenExpirationDate
        );
        this.setState(previousState => ({
          isLoggedIn: true,
          refreshToken: authState.refreshToken,
          accessToken: authState.accessToken,
        }));
        console.warn('Log in successful');
      },
      reason => {
        console.warn('Log in failed!' + reason);
      }
    );

    // Refresh token
    // const refreshedState = await refresh(config, {
    //   refreshToken: authState.refreshToken,
    // });
  }

  mapAppLogout() {
    const config = {
      issuer:
        'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp',
      clientId: clientId,
      redirectUrl: redirectUrl,
      scopes: ['openid', 'profile'],
    };

    // console.log(
    //   'curl -X POST -d \'{ "client_id" : "map-app-client", "client_secret":' +
    //     ' "b284cf4f-17e7-4464-987e-3c320b22cfac","refresh_token" :' +
    //     this.state.refreshToken +
    //     "}' -H" +
    //     ' "Content-Type:application/x-www-form-urlencoded" -H "Authorization: bearer ' +
    //     this.state.accessToken +
    //     '" https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/logout'
    // );

    // revoke(config, {
    //   tokenToRevoke: this.state.refreshToken,
    // }).then(
    //   value => {
    //     console.warn(value);
    //   },
    //   reason => {
    //     console.error(reason);
    //   }
    // );
    fetch(
      'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/logout?clientId=' +
        clientId +
        '&refresh_token=' +
        this.state.refreshToken +
        '&client_secret=' +
        clientSecret +
        '&redirect_uri=' +
        redirectUrlEncoded,
      {
        method: 'POST',
        headers: {
          Authorization: 'Bearer ' + this.state.accessToken,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      }
    ).then(
      value => {
        if (!value.ok) {
          console.warn('Log out not complete: ' + value.status);
        } else {
          this.setState(previousState => ({ isLoggedIn: false }));
        }
      },
      reason => {
        console.warn('Log out failed: ' + reason);
      }
    );
  }
}

class HelpScreen extends React.Component {
  static navigationOptions = {
    title: 'Help',
  };

  render() {
    const { navigate } = this.props.navigation;
    return (
      <View style={styles.container}>
        <Text style={styles.main}>This is a help page</Text>
        <Button
          style={styles.button}
          title="Go back Home"
          onPress={() => navigate('Home')}
        />
      </View>
    );
  }
}

const MainNavigator = createStackNavigator({
  Home: { screen: HomeScreen },
  Help: { screen: HelpScreen },
});

const styles = {
  container: {
    padding: 24,
  },
  button: {
    margin: 10,
  },
  main: {
    paddingBottom: 24,
  },
};

const App = createAppContainer(MainNavigator);

export default App;
