# CodeScanner
<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/b7ab5ae4-77b2-4045-ac23-dfafdd13fdea" alt="Login" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/1b9a7f57-a57e-4b85-82df-aa1712e68b5c" alt="Login text" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/91eabec1-8fb7-43b1-8611-b9e426f9f800" alet="Login alert" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/9a5e0200-0b6f-4d60-bb3c-4ba9ea471999" alt="Main Loading" width="200"/></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/17d724c4-5a71-4134-825a-768ae3a9a221" alt="Main more" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/2eb2c5ce-fdbd-4381-a375-8d782293b6bb" alt="Main sort" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/187fb632-5927-4e28-b20b-6a5042fce57f" alt="Detail" width="200"/></td>
  </tr>
</table>

## О проекте
Приложение для сканирования qr/barcode. RootView и AppCoordinator позволяет менять флоу, а также есть задел на подкачку каких-либо важных конфигов например. Также есть задел на более сложную навигацию. Реализовал свой di контейнер. За распознавание кодов отвечает FrameService, тогда как за работу камеры - CameraService. 
Реализовал расширяемый и кастомизируемый сетевой слой с логгированием, что позволяет удобно и наглядно видеть все что происходит.
По-хорошему еще нужно продумать лучше ui, внедрить system design и многое другое.

## Технологии
SwiftUI, MVVM, Core Data, AVFoundation, URLSession, Combine, Swift Concurrency(async/await)

## Платформа
iOS 16+

## Время выполнения
- Изучение тз, анализ, проектирование - 30 мин
- Базовая структура проекта - 1ч
- Модуль сканирования - 6ч 30м
- Навигация/алерты/таббар - 1ч
- Сетевой слой - 2ч
- UI - 5ч
- Core Data - 2ч
- Взаимосвязь данных - 6ч
- Ридми - 15м
- Всего - 24ч 15м
