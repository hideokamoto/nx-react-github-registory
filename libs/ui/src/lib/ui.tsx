import React from 'react';

import './ui.module.css';

/* eslint-disable-next-line */
export interface UiProps {}

export function Ui(props: UiProps) {
  return (
    <div>
      <h1>Welcome to UI!</h1>
      <pre><code>{JSON.stringify(props, null, 2)}</code></pre>
    </div>
  );
}

export default Ui;
