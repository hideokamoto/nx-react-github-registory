import React from 'react';

import './greeding.module.css';

/* eslint-disable-next-line */
export interface GreedingProps {}

export function Greeding(props: GreedingProps) {
  return (
    <div>
      <h1>Welcome to Greeding!</h1>
      <pre><code>{JSON.stringify(props, null, 2)}</code></pre>
    </div>
  );
}

export default Greeding;
