/**
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React from 'react';
import { Button, Text, View } from 'react-native';
import { createAppContainer, createStackNavigator } from 'react-navigation';
import { authorize } from 'react-native-app-auth';

const clientId = 'map-app-client';
const redirectUrl = 'edu.washington.cirg.mapapp:/callback';
const redirectUrlEncoded = 'edu.washington.cirg.mapapp%3A%2Fcallback';

const clientSecret = 'b284cf4f-17e7-4464-987e-3c320b22cfac';

class HomeScreen extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoggedIn: false,
      accessToken: null,
      accessTokenExpirationDate: null,
      refreshToken: null,
    };
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
      additionalParameters: { prompt: 'login' },
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
          accessTokenExpirationDate: authState.accessTokenExpirationDate,
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

    fetch(
      'https://poc-ohtn-keycloak.cirg.washington.edu/auth/realms/mapapp/protocol/openid-connect/logout?clientId=' +
        clientId +
        '&refresh_token=' +
        this.state.refreshToken +
        '&client_secret=' +
        clientSecret,
      {
        method: 'GET',
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
          console.warn('Logged out');
          this.setState(previousState => ({
            isLoggedIn: false,
            refreshToken: null,
            accessToken: null,
            accessTokenExpirationDate: null,
          }));
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
