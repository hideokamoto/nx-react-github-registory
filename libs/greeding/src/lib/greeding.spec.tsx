import React from 'react';
import { render } from '@testing-library/react';

import Greeding from './greeding';

describe('Greeding', () => {
  it('should render successfully', () => {
    const { baseElement } = render(<Greeding />);
    expect(baseElement).toBeTruthy();
  });
});
