import React from 'react'
import { render } from 'react-dom'

import {
    HashRouter as Router,
    Switch,
    Route,
} from 'react-router-dom'

const Nav = () => <h1>NYC Python (about) (splash)</h1>

const Main = () => (
    <>
        <h2>NYC Python</h2>
        <Events />
    </>
)

const Events = () => <h3>Events</h3>

const Splash = () => <h1>Splash</h1>

const About = () => <h1>About NYC Python</h1>

const Index = () => (
    <>
        <Nav />
        <Main />
    </>
)

const Root = () => (
    <Router>
        <Switch>
            <Route path="/"><Index /></Route>
            <Route path="/about"><About /></Route>
            <Route path="/splash"><Splash /></Route>
        </Switch>
    </Router>
)

render(
    <Root />,
    document.getElementById('root')
)
