---
title: Orb Detail View
shortTitle: Detail View
metaDescription: Explore the Orb app's detailed metrics screens to gain deeper insights into your network's performance over time.
section: Orb app
---

# Orb Detail View

The Orb detail view provides in-depth information about your network connectivity. This guide explains how to navigate and interpret the detailed metrics screens.

## Accessing the Detail View

You can access detailed metrics by tapping on any Orb card in the Orb Summary screen to open the detail view for that specific Orb. 

To access [advanced detail view](https://orb.net/docs/orb-app/orb-detail-view#advanced-detail-view), toggle on the chart icon.

<img src="../../images/orb-app/detail-view-toggle.png" alt="Orb Detail Advanced View" width=100%>

## Common Elements

All detail views share certain common elements:

### Time Period Selector

At the top of each detail view, you'll find a time period selector that allows you to view data across different time periods, including:

- Now (current snapshot of network connectivity)
- Last 5 minutes
- Last 1 hour
- Last 24 hours

<img src="../../images/orb-app/global-time-selector-2.png" alt="Time Selector" width=40% style="margin-left: 2em;">

### Orb Score and Status Message

On the left, you'll see your overall Orb Score for the time period selected.

<img src="../../images/orb-app/orb-score-and-status-message.png" alt="Orb Score Status" width=40% style="margin-left: 2em;">

There are indicators within the Orb Score that represent Responsiveness, Reliability, and Speed. When illuminated, the component is considered adequate for inclusion. If the indicator is dimmed, it indicates that while the the component is included, it may not be adequate (e.g. a stale speed score or not enough reliability data has been collected in the timeframe selected.)

<img src="../../images/orb-app/orb-score-indicators.png" alt="Score Indicators" width=30% style="margin-left: 2em;">

### Improve Connection

When your score is below 80, an "Improve Connection" button will appear. Tapping this button will provide you with tailored recommendations to improve your internet experience.

<img src="../../images/orb-app/improve-connection.png" alt="Improve Connection" width=40% style="margin-left: 2em;">

## Responsiveness and Reliability Detail

The Responsiveness detail view focuses on your connection's lag, latency, jitter, and packet loss for device-to-router and router-to-internet. Also included is DNS resolution time and time to first byte (TTFB) for the selected time period.

<img src="../../images/orb-app/simple-detail-responsiveness-expanded.png" alt="Responsiveness" width=60% style="margin-left: 2em;">

<img src="../../images/orb-app/advanced-detail-view.png" alt="Responsiveness" width=60% style="margin-left: 2em;">

The Reliability detail view focuses on your connection's stability. It includes the amount of time spent in the following states:
- Responsive
- Laggy
- Unresponsive
- Inactive

<img src="../../images/orb-app/simple-detail-reliability.png" alt="Reliability" width=60% style="margin-left: 2em;">

Clicking or tapping on a section in the timeline will highlight the performance for that slice of time.

The detail view displays Responsiveness and Reliability scores for the selected time period. Each of these contributes to your overall Orb Score. Tap on each card to expand and view more detailed metrics.

Each category is represented by:

- A score
- Detailed metrics
- Graphical representation of the data, when available

## Speed Detail

The Speed detail view focuses on your connection's throughput.

<img src="../../images/orb-app/speed-detail-expanded.png" alt="Speed" width=60% style="margin-left: 2em;"> 

### Checking Speed Score

- Speed Score checks are lightweight measurements performed on a one-hour cadence by default.
- These measurements are included in the Speed score and Orb Score, even when the measurement was performed outside of the selected time period.
- To disable or change the frequency of content speed measurements, use the dropdown menu in the expanded Speed card.

<img src="../../images/orb-app/speed-check-set-frequency.png" alt="Speed" width=60% style="margin-left: 2em;">

- The dropdown menu allows you to select from the following options:
  - Every 1 hour (default)
  - Every 4 hours
  - Every 6 hours
  - Every 24 hours
  - Never (disables content speed measurements)
- Content speed measurements can also be initiated at any time by the user.

### Initiating a Speed Test

- Full-buffer download and upload speed throughput measurements can be initiated at any time by the user.
- These results are informational only and not included in your speed or Orb Score.

### Advanced detail view
Switch to **Advanced Detail view** using the view toggle in the upper-right corner of the Orb detail screen. Advanced view provides time-series charts and additional diagnostic information for troubleshooting changes in network performance.

<img src="../../images/orb-app/detail-view-toggle.png" alt="Orb Detail Advanced View" width=100%>

<img src="../../images/orb-app/advanced-detail-view.png" alt="Orb Detail Advanced View" width=100%>

- **Wi-Fi**
  - Detailed Wi-Fi charts and connection information, including:
    - Wi-Fi Signal
    - Noise
    - Transmit Rate
    - SSID
    - BSSID
    - Channel
    - Band
    - Channel Width
    - PHY Mode

- **Nearby Wi-Fi Networks**
  - Scan for nearby Wi-Fi networks directly from the advanced detail screen
  - View neighboring networks and compare:
    - SSID
    - Band
    - Channel
    - Signal strength
  - Detect overlapping channel usage that may contribute to interference

<img src="../../images/orb-app/advanced-detail-view-scan.png" alt="Nearby Wi-Fi Networks" width=100%>
<img src="../../images/orb-app/advanced-detail-view-ap-scan-output.png" alt="Nearby Wi-Fi Networks" width=100%>

- **Filters and chart highlights**
  - Use activity filters to highlight periods associated with:
    - Testing Speed
    - Checking Speed Score
    - Network changes
    - Custom events/alerts based on rules
  - Highlighted regions on the charts make it easier to correlate score or responsiveness changes with Orb activity

<img src="../../images/orb-app/advanced-detail-view-filters.png" alt="Advanced View Filters" width=100%>

<img src="../../images/orb-app/advanced-detail-view filtered-charts.png" alt="Advanced View Filters" width=100%>

## Next Steps

To learn more about specific Orb metrics:

- [Understanding Speed metrics](/docs/orb-app/speed.md)
- [Understanding Reliability metrics](/docs/orb-app/reliability.md)
- [Understanding Responsiveness metrics](/docs/orb-app/responsiveness.md)
